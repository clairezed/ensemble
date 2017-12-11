class Language < ActiveRecord::Base

  # Associations ===============================================================

  has_many :user_languages, dependent: :destroy
  has_many :users, through: :user_languages

  # Validations ===============================================================

  validates :title, presence: true

  
end
