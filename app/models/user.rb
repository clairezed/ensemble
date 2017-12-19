class User < ApplicationRecord
  
  # Configurations =============================================================
  include Sortable
  include AASM
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  attr_accessor :sms_token 

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
  has_many :leisures, -> { uniq }, through: :leisure_interests
  has_many :leisure_categories, -> { uniq }, through: :leisures

  has_many :user_languages, dependent: :destroy
  has_many :languages, through: :user_languages

  has_many :organized_events, class_name: 'Event', dependent: :destroy

  has_many :event_participations, dependent: :destroy
  has_many :participated_events, class_name: 'Event', source: :event, through: :event_participations
  has_many :events, ->(user) { unscope(where: :user_id).with_user(user.id) }

  # Validations ==================================================================
  validates :lastname,
            :firstname,
            presence: true

  with_options if: :persisted? do |user|
    user.validates :gender,
      :phone,
      :birthdate,
      :city,
      presence: true

    # user.validates_format_of :phone, with: /\A\+?[1-9]\d{1,14}\z/
  end

  before_validation :format_phone_number, if: :phone_changed?
  private def format_phone_number
    self.phone = User::FormatPhoneNumber.call(self.phone)
  end


  # Scopes ======================================================================

  scope :email_notified, -> { where email_notification: true}
  scope :sms_notified, -> { where sms_notification: true}

  scope :by_name_or_email, -> (val) {
    val.downcase!
    where(arel_table[:firstname].matches("%#{val}%").or(
          arel_table[:lastname].matches("%#{val}%").or(
          arel_table[:email].matches("%#{val}%"))))
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

  # Callbacks ==================================================================


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

  # def self.apply_sorts(params)
  #   # default sorting
  #   params[:sort_by] ||= DEFAULT_SORTING_OPTION

  #   SORTING_OPTIONS.inject(all) do |relation, filter|
  #     next relation unless params[:sort_by].to_sym == filter
  #     relation.send(filter)
  #   end
  # end

  # def self.apply_filters(params)
  #   klass = self

  #   # klass = klass.by_title(params[:by_title]) if params[:by_title].present?
  #   return self unless self.is_a?(ActiveRecord::Relation)

  #   klass.apply_sorts(params)
  # end

  # Instance methods ====================================================

  # Picture --------------------------------------------------------------

  # Url pointant soit vers le avatar, soit vers l'image par défaut du format
  # demandé
  #
  def avatar_url(format)
    self.avatar ? self.avatar.asset(format) : self.build_avatar.asset(format)
  end


  # Vérification ==================================================================

  # Sms confirmation --------------------------------------------------------------

  # Fortement inspirée du code de Devise 
  # https://github.com/plataformatec/devise/blob/ee01bac8b0b828b3da0d79c46115ba65c433d6c8/lib/devise/models/confirmable.rb
  def sms_confirmed?
    !sms_confirmed_at.blank?
  end

  def sms_confirmation_period_valid?
    User.allow_unconfirmed_access_for.nil? || (sms_confirmation_sent_at && sms_confirmation_sent_at.utc >= User.allow_unconfirmed_access_for.ago)
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
