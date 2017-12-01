class City < ActiveRecord::Base

  # Configurations =============================================================

  # Associations ===============================================================

  has_many :users, dependent: :nullify

  # Validations ===============================================================
  validates :name, :zipcode, :department_code, presence: true

  # Scopes ===============================================================
  scope :by_name_or_zipcode, ->(name_or_zip) {
    zipcode = name_or_zip.to_s.strip[/\A\d+\z/]
    name_or_zip   = name_or_zip.gsub(/^SAINT(E)? (.*)/i, "ST\\1 \\2")
    where(
      arel_table[ zipcode.blank? ? :normalized_name : :zipcode ].matches("#{ActiveSupport::Inflector.transliterate(name_or_zip)}%")
    ).order(:zipcode)
  }

  # Instance methods ===============================================================

  def long_name
    [zipcode, name].join(' ')
  end

  
  private


end
