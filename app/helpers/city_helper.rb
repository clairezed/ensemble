# frozen_string_literal: true

module CityHelper

  def single_city_options(val)
    if val.blank?
      city = current_user.city
    else
      city = val.is_a?(City) ? val : City.find(val)
      city = current_user.city if city.blank?
    end
    return '' if city.blank?
    [[city.name, city.id]]
  end
end