class User < ApplicationRecord
  
  # Configurations =============================================================
  include Sortable
  include AASM
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  attr_accessor :sms_token, :cgu_accepted

  enum gender: { 
    female: 0, 
    male: 1
  }

  enum affiliation: { 
    normal: 0, 
    mirador: 1
  }

  enum verification_state: {
    pending: 0,
    identity_verified: 1, # mail et sms vérifié
    admin_accepted: 2,
    admin_rejected: 3
  }

  aasm column: :verification_state, enum: true do

    state :pending, initial: true
    state :identity_verified
    state :admin_accepted
    state :admin_rejected

    event :verify_identity, after: [:notify_admin_for_validation] do
      transitions from: :pending, to: :identity_verified
    end

    event :admin_accept do
      transitions from: :identity_verified, to: :admin_accepted
      transitions from: :admin_rejected, to: :admin_accepted
    end

    # TODO : notify_user, cancel_events, block ip & email
    event :admin_reject do
      transitions from: :identity_verified, to: :admin_rejected
      transitions from: :admin_accepted, to: :admin_rejected
    end

    event :retrograde do
      transitions from: :identity_verified, to: :pending
      transitions from: :admin_accepted, to: :pending
      transitions from: :admin_rejected, to: :pending
    end

  end


  private def notify_admin_for_validation
    AdminMailer.user_to_verify(self).deliver_later
  end

  # Associations ===============================================================

  belongs_to :city, optional: true

  has_one :avatar,
          class_name: '::Asset::UserAvatar',
          as: :assetable,
          dependent: :destroy
  accepts_nested_attributes_for :avatar, allow_destroy: true

  has_many :leisure_interests, dependent: :destroy
  has_many :leisures, -> { distinct }, through: :leisure_interests
  has_many :leisure_categories, -> { distinct }, through: :leisures

  has_many :user_languages, dependent: :destroy
  has_many :languages, through: :user_languages

  has_many :organized_events, class_name: 'Event', dependent: :destroy

  has_many :event_participations, dependent: :destroy
  has_many :participated_events, class_name: 'Event', source: :event, through: :event_participations
  has_many :events, ->(user) { unscope(where: :user_id).with_user(user.id) }

  has_many :event_invitations, dependent: :destroy

  # Validations ==================================================================
  validates :lastname,
            :firstname,
            presence: true

  # validates :phone, uniqueness: true

  with_options if: :persisted? do |user|
    user.validates :gender,
      :phone,
      :birthdate,
      :city_id,
      presence: true
    user.validates :phone, uniqueness: true, if: :phone?
    user.validate :at_least_one_leisure
  end

  private def at_least_one_leisure
    errors.add(:base, :at_least_one_leisure) if self.leisures.empty?
  end


  validates :cgu_accepted,
          acceptance: {message: "doivent être acceptées"}


   
  # Callbacks ==================================================================

  before_validation :format_phone_number, if: :phone_changed?
  private def format_phone_number
    self.phone = User::FormatPhoneNumber.call(self.phone)
  end

  # Verification process -------------------------------------------------------

  after_update :check_email_confirmation, if: :saved_change_to_unconfirmed_email?
  private def check_email_confirmation
    self.update_column(:confirmed_at, nil) unless unconfirmed_email.blank?
    set_verification_state
  end

  after_update :check_sms_confirmation, if: :saved_change_to_phone?
  private def check_sms_confirmation
    self.update_column(:sms_confirmed_at, nil)
    Twilio::SendConfirmationMessage.call(self)
    set_verification_state
  end

  def set_verification_state
    unless (confirmed? && sms_confirmed?)
      # self.retrograde! if may_retrograde?
      self.update_column(:verification_state, 'pending')
    end
  end


  # Scopes ======================================================================

  scope :visible, -> { with_registration_completed.not_admin_rejected }

  scope :with_registration_completed, -> { where registration_complete: true }
  scope :not_admin_rejected, -> { where.not(verification_state: verification_states[:admin_rejected])}


  scope :email_notified, -> { where email_notification: true}
  scope :sms_notified, -> { where sms_notification: true}

  # filtering ---------------------------------------------

  scope :by_name_or_email, -> (val) {
    val.downcase!
    where(arel_table[:firstname].matches("%#{val}%").or(
          arel_table[:lastname].matches("%#{val}%").or(
          arel_table[:email].matches("%#{val}%"))))
  }

  scope :by_nickname, -> (val='', options) {
    return none if (val.blank? && options[:strict] == true)
    val.downcase!
    where(arel_table[:firstname].matches("%#{val}%"))
  }

  scope :by_verification_state, ->(state) {
    where(verification_state: verification_states.fetch(state.to_sym))
  }

  scope :by_leisure_category, -> (val) {
    joins(:leisure_interests).merge(LeisureInterest.by_leisure_category(val))
  }

  scope :by_leisure, -> (val) {
    joins(:leisure_interests).merge(LeisureInterest.by_leisure(val))
  }

  scope :minus, -> (id) {
    where.not(id: id)
  }


  # Class Methods ==============================================================

  def self.blocked_ips
    self.admin_rejected
      .map{|u| [u.current_sign_in_ip, u.last_sign_in_ip]}
      .flatten
      .compact
  end

    def self.apply_filters(params)
    [
      :by_name_or_email,
      :by_verification_state,
    ].inject(all) do |relation, filter|
      next relation unless params[filter].present?
      relation.send(filter, params[filter])
    end
    relation.apply_sorts(params)
  end

  # Instance methods ====================================================

  # Picture --------------------------------------------------------------

  # Url pointant soit vers le avatar, soit vers l'image par défaut du format
  # demandé
  #
  def avatar_url(format)
    self.avatar ? self.avatar.asset(format) : self.build_avatar.asset(format)
  end

  def nickname
    @nickname ||= [firstname, initials(lastname)].join(" ")
  end

  def initials(val)
    val.split.map{|v| v[0].capitalize }.join('')
  end

  def fullname
    [firstname, lastname].join(" ")
  end


  # Vérification ==================================================================

  # Sms confirmation --------------------------------------------------------------

  # Fortement inspirée du code de Devise 
  # https://github.com/plataformatec/devise/blob/ee01bac8b0b828b3da0d79c46115ba65c433d6c8/lib/devise/models/confirmable.rb
  def sms_confirmed?
    !sms_confirmed_at.blank?
  end

  def sms_confirmation_period_valid?
    User.allow_unconfirmed_access_for.nil? || !registration_complete? || (sms_confirmation_sent_at.present? && sms_confirmation_sent_at.utc >= User.allow_unconfirmed_access_for.ago)
  end

  def sms_confirmation_required?
    !sms_confirmed? && !sms_confirmation_period_valid?
  end

  # active_for_authentication --------------------------------------------------------------

  def active_for_authentication? 
    super && !sms_confirmation_required? && !admin_rejected?
  end

  def inactive_message 
    if admin_rejected? 
      :admin_rejected 
    elsif sms_confirmation_required?
      :unconfirmed
    else
      super # Use whatever other message 
    end 
  end

  # Event participation -------------------------------------------------

  def participation_at(event)
    self.event_participations.find_by_event_id(event.id)
  end


end
