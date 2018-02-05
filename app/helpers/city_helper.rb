# frozen_string_literal: true

module CityHelper

  def single_city_options(val)
    if val.blank?
      city = current_user.city
    else
      city = val.is_a?(City) ? val : City.find(val)
      city = current_user.city if city.blank?
    end
    city = City.default_city if city.blank?
    return departement_cities_options(city)
  end

  def departement_cities_options(city)
    departement_cities_id = City.where(department_code: city.department_code).limit(15).pluck(:id)
    city_options(City.where(id: departement_cities_id))
  end

  def city_options(citys = City.all)
    citys.map do |city|
      [city.name, city.id]
    end
  end

end