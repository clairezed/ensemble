class City < ActiveRecord::Base

  # Configurations =============================================================
  reverse_geocoded_by :latitude, :longitude
  # Associations ===============================================================

  has_many :users, dependent: :nullify

  # Validations ===============================================================
  validates :name, :zipcode, :department_code, presence: true

  # Scopes ===============================================================
  scope :by_name_or_zipcode, ->(name_or_zip) {
    # return none if name_or_zip.blank?
    zipcode = name_or_zip.to_s.strip[/\A\d+\z/]
    name_or_zip  = name_or_zip.gsub(/^SAINT(E)? (.*)/i, "ST\\1 \\2")
    where(
      arel_table[ zipcode.blank? ? :normalized_name : :zipcode ].matches("#{ActiveSupport::Inflector.transliterate(name_or_zip)}%")
    ).order(:zipcode)
  }

  scope :nearest_first, -> (coordinates) { near(coordinates, 250, units: :km) }

  # Class methods =================================================================

  def self.default_city
    self.find_by(normalized_name: "epinal")
  end

  # Instance methods ===============================================================

  def long_name
    [zipcode, name].join(' ')
  end

  def coordinates
    [latitude, longitude]
  end

  
  private


end
