class Leisure < ActiveRecord::Base

  # Associations ===============================================================

  belongs_to :leisure_category
  has_many :leisure_interests, dependent: :destroy
  has_many :users, through: :leisure_interests

  # Validations ===============================================================

  validates :title, :leisure_category, 
  presence: true

  # Scopes =====================================================================

  scope :by_leisure_category, -> (val_id) {
    where(leisure_category_id: val_id)
  }

  # scope restrictif pour gérer les options select2 du référentiel
  scope :by_leisure_category_restrict, -> (val_id) {
    return none if val_id.blank?
    by_leisure_category(val_id)
  }

  # Class Methods ==============================================================
  
  def self.apply_filters(params)
    klass = self
    # raise (params[:by_leisure_category_restrict].nil?).inspect
    klass = klass.by_leisure_category(params[:by_leisure_category]) if params[:by_leisure_category].present?
    klass = klass.by_leisure_category_restrict(params[:by_leisure_category_restrict]) unless params[:by_leisure_category_restrict].nil?

    klass
  end
  
end
