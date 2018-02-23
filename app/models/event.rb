class Event < ApplicationRecord
  
  # Configurations =============================================================
  include Sortable
  include PgSearch
  include AASM

  attr_accessor :start_date, :start_time

  pg_search_scope :by_text, 
    :against => { :title => 'A', :description => 'B' }, 
    :using => { :tsearch => {:prefix => true} },
    :ignoring => :accents

  enum visibility: { 
    opened: 0, 
    closed: 1
  }

  enum affiliation: { 
    normal: 0, 
    mirador: 1
  }


  # états de publication et validation par l'admin
  #
  enum state: {
    active:   0, # brouillon
    canceled: 1, # en attente de validation
  }

  aasm column: :state, enum: true do

    state :active, initial: true
    state :canceled
    state :active

    event :cancel, after: [:notify_cancelation_to_participants] do
      transitions from: :active, to: :canceled
    end

    event :activate do
      transitions from: :canceled, to: :active
    end

  end

  private def notify_cancelation_to_participants
    SendNotification.event_canceled(self)
  end

  # Associations ===============================================================

  belongs_to :user
  belongs_to :city
  # TODO : remove optional
  # belongs_to :leisure_category, optional: true
  belongs_to :leisure
  has_one :leisure_category, through: :leisure

  has_many :pictures,
            class_name: :'::Asset::EventPicture',
            as:         :assetable,
            dependent:  :destroy

  has_many :attachments,
            class_name: :'::Asset::EventAttachment',
            as:         :assetable,
            dependent:  :destroy
  accepts_nested_attributes_for :attachments, allow_destroy: true

  has_many :event_participations, dependent: :destroy
  has_many :participants, class_name: 'User', source: :user, through: :event_participations

  has_many :event_invitations, dependent: :destroy
  has_many :invited_users, class_name: 'User', source: :user, through: :event_invitations

  has_many :comments, dependent: :destroy
  has_many :accepted_comments, -> { accepted }, class_name: 'Comment', dependent: :destroy

  has_many :testimonies, dependent: :destroy
  has_many :accepted_testimonies, -> { accepted }, class_name: 'Testimony', dependent: :destroy

  # Validations ==================================================================
  validates :title,
            :start_at,
            :city_id,
            :leisure_id,
            presence: true

  def valid_bounds?
    return true if bounded? && start_at < end_at
    errors.add(:end_date, :invalid_bounds)
    false
  end
  validate :valid_bounds?, if: :bounded?


  # Scopes ======================================================================

  scope :past, -> { where(
    (arel_table[:end_at].not_eq(nil).and(arel_table[:end_at].lt(Time.zone.now)))
    .or(arel_table[:end_at].eq(nil).and(arel_table[:start_at].lt(Time.zone.now.beginning_of_day)))
    )
  }

  scope :ended_at, -> (date = Date.yesterday) { where(
    (arel_table[:end_at].not_eq(nil).and(arel_table[:end_at].lt(date.end_of_day).and(arel_table[:end_at].gteq(date.beginning_of_day))))
    .or(arel_table[:end_at].eq(nil).and(arel_table[:start_at].lt(date.end_of_day).and(arel_table[:start_at].gteq(date.beginning_of_day))))
    )
  }

  scope :future, -> { where(
    (arel_table[:end_at].not_eq(nil).and(arel_table[:end_at].gteq(Time.zone.now)))
    .or(arel_table[:end_at].eq(nil).and(arel_table[:start_at].gteq(Time.zone.now.beginning_of_day)))
    )
  }

  scope :visible, -> {
    opened.future.active
  }

  scope :blocked_to, -> (user_id) {
    joins(:user).merge(User.blocking(user_id))
  }

  scope :not_blocked_to, -> (user_id) {
    where.not(user_id: User.blocking(user_id))
  }

  scope :organized_by, -> (user_id) {
    where(arel_organized_by(user_id))
  }

  scope :with_participant, -> (user_id) {
    eager_load(:event_participations)
    .where(arel_with_participant(user_id))
  }

  scope :with_user, -> (user_id) {
    eager_load(:event_participations)
    .where(arel_organized_by(user_id)
      .or(arel_with_participant(user_id))
    )
  }

  def self.arel_organized_by(val)
    Event.arel_table[:user_id].eq(val)
  end

  def self.arel_with_participant(val)
    EventParticipation.arel_table[:user_id].eq(val)
  end

  # Search -------------------------------------------

  scope :by_leisure_category, -> (val) {
    joins(:leisure).merge(Leisure.by_leisure_category(val))
  }

  scope :by_leisure, -> (val) {
    where(leisure_id: val)
  }

  scope :by_leisures, -> (vals) {
    break all if vals.all?(&:blank?)
    where(leisure_id: vals)
  }

  scope :by_start_at, -> (val) {
    where arel_table[:start_at].gteq(val.to_time)
  }

  scope :by_end_at, -> (val) {
    where arel_table[:start_at].lteq(val.to_time)
  }

  scope :by_city, -> (val) {
    where city_id: val
  }

  # Ordering ----------------------------------------

  scope :next_in_time, -> { order(start_at: :asc) }

  scope :older_last, -> { order(start_at: :desc) }

  scope :nearest_first, -> (coordinates) { 
    eager_load(:city).merge(City.nearest_first(coordinates))
  }

  scope :default_sort, -> (coordinates) {
    nearest_first(coordinates).next_in_time
  }

  # Admin 

  scope :by_state, ->(state) {
    where(state: states.fetch(state.to_sym))
  }

  scope :by_visibility, ->(visibility) {
    where(visibility: visibilities.fetch(visibility.to_sym))
  }

 
  # Class Methods ==============================================================

  def self.apply_filters(params)
    [
      :by_text,
      :by_leisure_category,
      :by_leisures,
      :by_start_at,
      :by_end_at,
      :by_city,
      :by_state,
      :by_visibility
    ].inject(all) do |relation, filter|
      next relation unless params[filter].present?
      relation.send(filter, params[filter])
    end
  end


  # Instance methods ====================================================

  # DateTime ----------------------------------------
  
  def bounded?
    start_at && end_at
  end

  def start_date
    start_at.try(:to_date)
  end

  def start_time
    start_at.strftime("%H:%M") rescue nil
  end

  def end_date
    end_at.try(:to_date)
  end

  def end_time
    end_at.strftime("%H:%M") rescue nil
  end

  def past?
    if end_at.present?
      end_at < Time.zone.now
    else
      start_at < Time.zone.now.beginning_of_day
    end
  end

  def future?
    if end_at.present?
      end_at >= Time.zone.now
    else
      start_at >= Time.zone.now.beginning_of_day
    end
  end

  def visible?
    future? && active?
  end

  # Management

  def full?
    participants.count >= participants_max
  end

  # Participants -------------------------

  def with_mirador_participant?
    participants.mirador.any?
  end

end
