class Testimony < ApplicationRecord
  
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

    event :accept, after: [:touch_accepted_at] do
      transitions from: :pending, to: :accepted
      transitions from: :rejected, to: :accepted
    end

    event :reject do
      transitions from: :pending, to: :rejected
      transitions from: :accepted, to: :rejected
    end

  end

  private def touch_accepted_at
    self.touch(:accepted_at)    
  end

  # Associations ===============================================================

  belongs_to :user
  belongs_to :event

  # Validations ==================================================================
  private def at_least_one_comment
    return true if (public_comment.present? || admin_comment.present?)
    errors.add(:base, "Vous devez écrire au moins un commentaire (public ou admin)")
  end
  validate :at_least_one_comment

  # Callbacks ===================================================================


  private def notify_admin
    AdminMailer.testimony_to_verify(self).deliver_later
  end
  after_create :notify_admin


  # Scopes ======================================================================

  # Admin -----------------------------

  scope :by_state, ->(state) {
    where(state: states.fetch(state.to_sym))
  }

  scope :by_user, ->(user_id){
    where(user_id: user_id)
  }

  scope :by_user_fullname, ->(hint){
    joins(:user).merge(User.full_text_search hint)
  }

  scope :sort_by_user_fullname, ->(direction = :asc){
    joins(:user).merge(User.sort_by_fullname direction)
  }


  # Class Methods ==============================================================

  def self.apply_filters(params)
    [
      :by_state,
      :by_user,
    ].inject(all) do |relation, filter|
      next relation unless params[filter].present?
      relation.send(filter, params[filter])
    end
    relation.apply_sorts(params)
  end

  # Instance methods ====================================================



end
