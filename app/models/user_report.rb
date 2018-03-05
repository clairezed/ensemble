class UserReport < ApplicationRecord
  include Sortable
  # Enums --------------------------------------------------

  # Associations ===============================================================

  belongs_to :reported_user, class_name: 'User'
  belongs_to :user

  validates :reported_user_id, :user_id, presence: true

  # Scopes =====================================================================

  scope :active, -> { where blocked: true }

  scope :reporting, -> (user_id) {where reported_user_id: user_id}
  scope :by_user, -> (user_id) { where user_id: user_id }

  scope :blocking, -> (user_id) { active.reporting(user_id) }

  # Instance methods =========================================

    # Class Methods ==============================================================
  
  def self.apply_filters(params)
    klass = self
    klass = klass.reporting(params[:reporting]) if params[:reporting].present?
    klass = klass.blocking(params[:blocking]) if params[:blocking].present?
    klass = klass.by_user(params[:by_user]) if params[:by_user].present?
    klass
  end

end
