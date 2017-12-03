class LeisureInterest < ApplicationRecord

  # Enums --------------------------------------------------


   # Associations ===============================================================

  belongs_to :leisure
  belongs_to :user

  # Validations ===============================================================
  validates :leisure_id, uniqueness: { scope: :user_id }

  # Scopes =====================================================================
  scope :persisted, -> { where.not(id: nil)}

  # Instance methods =========================================



  protected 



end
