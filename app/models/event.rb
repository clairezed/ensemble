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


  # Validations ==================================================================
  validates :title,
            :start_at,
            presence: true

  def valid_bounds?
    return true if bounded? && start_at < end_at
    errors.add(:end_date, :invalid_bounds)
    false
  end
  validate :valid_bounds?, if: :bounded?


  # Scopes ======================================================================

  scope :future, -> {
    where(arel_table[:start_at].gteq(Date.current))
  }

  scope :visible, -> {
    opened.future.active
  }

  scope :past, -> {
    where(arel_table[:start_at].lt(Date.current))
  }

  scope :organized_by, -> (user_id) {
    where(user_id: user_id)
  }

  scope :with_participant, -> (user_id) {
    where(event_participations: {user_id: user_id})
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
    where(leisure_category_id: val)
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
  scope :nearest_first, -> (coordinates) { 
    eager_load(:city).merge(City.nearest_first(coordinates))
  }

  # Admin 

  scope :by_state, ->(state) {
    where(state: states.fetch(state.to_sym))
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
    ].inject(all) do |relation, filter|
      next relation unless params[filter].present?
      relation.send(filter, params[filter])
    end
  end

  # def self.apply_sorts(params)
  #   # default sorting
  #   # params[:sort_by] ||= DEFAULT_SORTING_OPTION
  #   # [
  #   #   # :nearest_first
  #   #   :next_in_time,
  #   # ].inject(all) do |relation, filter|
  #   #   next relation unless params[:sort_by].to_sym == filter
  #   #   relation.send(filter)
  #   # end
  #   all
  # end

  # def self.apply_filters(params)
  #   klass = self

  #   # klass = klass.by_title(params[:by_title]) if params[:by_title].present?
  #   return self unless self.is_a?(ActiveRecord::Relation)

  #   klass.apply_sorts(params)
  # end

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
    start_at < Time.current
  end

  def future?
    start_at >= Time.current
  end

  def visible?
    future? && active?
  end

  # Management

  def full?
    participants.count >= participants_max
  end

end
