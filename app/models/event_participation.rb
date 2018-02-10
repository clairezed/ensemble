class EventParticipation < ApplicationRecord

  # Enums --------------------------------------------------

  # Associations ===============================================================

  belongs_to :event
  belongs_to :user

  # Validations ===============================================================
  validates :event_id, uniqueness: { scope: :user_id }

  # Scopes =====================================================================
  scope :persisted, -> { where.not(id: nil)}

  # Instance methods =========================================

    def event_not_full?
      return true unless event.full?
      errors.add(:base, "L'événement est complet, vous ne pouvez pas y participer.")
      false
    end
    validate :event_not_full?, on: :create, if: ->(p) { p.event.opened? }

  protected 



end
