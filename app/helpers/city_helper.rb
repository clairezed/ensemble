# frozen_string_literal: true

module CityHelper

  def single_city_options(val)
    return '' if val.blank?
    city = val.is_a?(City) ? val : City.find(val)
    return '' if city.blank?
    [[city.name, city.id]]
  end
end