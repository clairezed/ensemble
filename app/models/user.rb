class User < ApplicationRecord
  
  # Configurations =============================================================
  include Sortable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum gender: { 
    female: 0, 
    male: 1
  }

  # Associations ===============================================================

  belongs_to :city, optional: true

  # Validations ==================================================================
  validates :lastname,
            :firstname,
            presence: true

  # Class Methods ==============================================================

  #   def self.apply_filters(params)
  #   [
  #     :by_text,
  #     :by_competences,
  #   ].inject(all) do |relation, filter|
  #     next relation unless params[filter].present?
  #     relation.send(filter, params[filter])
  #   end
  # end

  # def self.apply_sorts(params)
  #   # default sorting
  #   params[:sort_by] ||= DEFAULT_SORTING_OPTION

  #   SORTING_OPTIONS.inject(all) do |relation, filter|
  #     next relation unless params[:sort_by].to_sym == filter
  #     relation.send(filter)
  #   end
  # end

  def self.apply_filters(params)
    klass = self

    # klass = klass.by_title(params[:by_title]) if params[:by_title].present?
    return self unless self.is_a?(ActiveRecord::Relation)

    klass.apply_sorts(params)
  end


end
