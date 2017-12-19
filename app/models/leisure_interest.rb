class LeisureInterest < ApplicationRecord

  # Enums --------------------------------------------------


   # Associations ===============================================================

  belongs_to :leisure
  belongs_to :user

  # Validations ===============================================================
  validates :leisure_id, uniqueness: { scope: :user_id }

  # Scopes =====================================================================
  scope :persisted, -> { where.not(id: nil)}

  scope :by_leisure, -> (val) {
    where(leisure_id: val)
  }

  scope :by_leisure_category, -> (val) {
    joins(:leisure).merge(Leisure.by_leisure_category(val)).distinct
  }

  # Instance methods =========================================



  protected 



end
