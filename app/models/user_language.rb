class UserLanguage < ApplicationRecord

  # Enums --------------------------------------------------


   # Associations ===============================================================

  belongs_to :language
  belongs_to :user

  # Validations ===============================================================
  validates :language_id, uniqueness: { scope: :user_id }

  # Scopes =====================================================================
  scope :persisted, -> { where.not(id: nil)}

  # Instance methods =========================================



  protected 



end
