class User < ApplicationRecord
  
  # Configurations =============================================================
  include Sortable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  enum gender: { 
    female: 0, 
    male: 1
  }

  enum affiliation: { 
    normal: 0, 
    mirador: 1
  }

  # Associations ===============================================================

  belongs_to :city, optional: true

  has_one :avatar,
          class_name: '::Asset::UserAvatar',
          as: :assetable,
          dependent: :destroy
  accepts_nested_attributes_for :avatar, allow_destroy: true

  has_many :leisure_interests, dependent: :destroy
  has_many :leisures, through: :leisure_interests

  # Validations ==================================================================
  validates :lastname,
            :firstname,
            presence: true

  with_options if: :persisted? do |user|
    user.validates :gender,
      :phone,
      :birthdate,
      :city,
      presence: true
  end

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

  # Instance methods ====================================================

  # Picture --------------------------------------------------------------

  # Url pointant soit vers le avatar, soit vers l'image par défaut du format
  # demandé
  #
  def avatar_url(format)
    self.avatar ? self.avatar.asset(format) : self.build_avatar.asset(format)
  end


end
