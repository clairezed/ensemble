class Comment < ApplicationRecord
  
  # Configurations =============================================================
  include Sortable
  include AASM

  # états de publication et validation par l'admin
  #
  enum state: {
    pending:  0, # brouillon
    accepted: 1, # accepte
    rejected: 2, # refuse
  }

  aasm column: :state, enum: true do

    state :pending, initial: true
    state :accepted
    state :rejected

    event :accept, after: [:notify_organizer] do
      transitions from: :pending, to: :accepted
      transitions from: :rejected, to: :accepted
    end

    event :reject, after: [:notify_rejection] do
      transitions from: :pending, to: :rejected
      transitions from: :accepted, to: :rejected
    end

  end

  private def notify_organizer
    recipient = self.event.user
    SendNotification.new_comment_on_your_event(recipient, self)
  end

  private def notify_rejection
    SendNotification.comment_rejected(self)
  end

  # Associations ===============================================================

  belongs_to :user
  belongs_to :event

  # Validations ==================================================================
  validates :body,
            presence: true

  # Callbacks ===================================================================


  private def notify_admin
    AdminMailer.comment_to_verify(self).deliver_later
  end
  after_create :notify_admin


  # Scopes ======================================================================

  # Admin 

  scope :by_state, ->(state) {
    where(state: states.fetch(state.to_sym))
  }
 
  # Class Methods ==============================================================

  def self.apply_filters(params)

        klass = self

    klass = klass.by_state(params[:by_state]) if params[:by_state].present?
    # klass = klass.by_prestation_restrict(params[:by_prestation_restrict]) if params[:by_prestation_restrict].present?

    klass

    
    # p self
    # klass = self
    # [
    #   :by_state,
    # ].inject(klass) do |relation, filter|
    #   p relation
    #   next relation unless params[filter].present?
    #   relation.send(filter, params[filter])
    # end
    # p klass
    # relation
    # relation.apply_sorts(params)
  end

  # Instance methods ====================================================



end
