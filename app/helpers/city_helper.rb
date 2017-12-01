# frozen_string_literal: true

module CityHelper

  def single_city_options(city)
    return '' if city.blank?
    [[city.name, city.id]]
  end
end