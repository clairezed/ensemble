class LeisureCategory < ActiveRecord::Base
  include Sortable
  # Associations ===============================================================

  has_many :leisures, dependent: :destroy

  # Validations ===============================================================
  
  validates :title,
  presence: true

end
