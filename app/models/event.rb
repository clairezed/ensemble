class Event < ApplicationRecord
  
  # Configurations =============================================================
  include Sortable

  enum visibility: { 
    open: 0, 
    closed: 1
  }

  enum affiliation: { 
    normal: 0, 
    mirador: 1
  }

  include AASM

  # états de publication et validation par l'admin
  #
  enum state: {
    pending:   0, # brouillon
    accepted: 1, # en attente de validation
    rejected:  2  # accepté
  }

  aasm column: :state, enum: true do

    state :pending, initial: true
    state :accepted
    state :active

    event :accept, after: [:notify_acceptance] do
      transitions from: :pending, to: :accepted
    end

    event :reject,  after: [:notify_rejection] do
      transitions from: :pending, to: :rejected
      transitions from: :accepted, to: :rejected
    end

  end

  private def notify_acceptance
    p "TODO notify_acceptance"
  end
  private def notify_rejection
    p "TODO notify_rejection"
  end

  # Associations ===============================================================

  belongs_to :user
  belongs_to :city
  # TODO : remove optional
  belongs_to :leisure_category
  belongs_to :leisure, optional: true

  # has_many :attachments,
  #           class_name: :'::Asset::EventAttachment',
  #           as:         :assetable,
  #           dependent:  :destroy
  # accepts_nested_attributes_for :attachments, allow_destroy: true

  has_many :event_participations, dependent: :destroy
  has_many :participants, class_name: 'User', source: :user, through: :event_participations

  # Validations ==================================================================
  validates :title,
            :start_at,
            presence: true

  # Scopes ======================================================================

  scope :future, -> {
    where(arel_table[:start_at].gteq(Date.current))
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
 
  # Class Methods ==============================================================

    def self.apply_filters(params)
    [
      # :by_text,
      # :by_competences,
    ].inject(all) do |relation, filter|
      next relation unless params[filter].present?
      relation.send(filter, params[filter])
    end
  end

  def self.apply_sorts(params)
    # default sorting
    # params[:sort_by] ||= DEFAULT_SORTING_OPTION

    # SORTING_OPTIONS.inject(all) do |relation, filter|
    #   next relation unless params[:sort_by].to_sym == filter
    #   relation.send(filter)
    # end
    all
  end

  # def self.apply_filters(params)
  #   klass = self

  #   # klass = klass.by_title(params[:by_title]) if params[:by_title].present?
  #   return self unless self.is_a?(ActiveRecord::Relation)

  #   klass.apply_sorts(params)
  # end

  # Instance methods ====================================================

end
