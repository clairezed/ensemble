class LeisureCategory < ActiveRecord::Base

  # Associations ===============================================================

  has_many :leisures, dependent: :destroy

  # Validations ===============================================================
  
  validates :title,
  presence: true

end
