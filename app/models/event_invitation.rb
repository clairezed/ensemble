class EventInvitation < ApplicationRecord

  # Config --------------------------------------------------
  include AASM
  
  enum state: {
    draft: 0,
    pending: 1,
    accepted: 2,
    rejected: 3
  }

  aasm column: :state, enum: true do

    state :draft, initial: true
    state :pending
    state :accepted
    state :rejected

    # TODO notifiy invited_user
    event :validate, after: [:notify_invitation]  do
      transitions from: :draft, to: :pending
    end

    event :accept do
      transitions from: :pending, to: :accepted
    end

    # TODO : notify_user, cancel_events, block ip & email
    event :reject do
      transitions from: :pending, to: :rejected
    end

  end

  private def notify_invitation
    SendNotification.new_invitation(self)
  end

  # Associations ===============================================================

  belongs_to :event
  belongs_to :user

  # Validations ===============================================================
  validates :event_id, uniqueness: { scope: :user_id }

  # Scopes =====================================================================
  scope :persisted, -> { where.not(id: nil)}

  # Instance methods =========================================



  protected 



end
