# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'csv'


a1 = Admin.where(email: 'clairezuliani@gmail.com').first_or_create(password: 'password')

Seo.where(param: 'home').first_or_create

# Import villes
CSV.foreach("docs/communes_gps.csv",{headers: :true, col_sep: ';'}) do |row|
  city = City.where(insee: row['10_code_insee']).first_or_initialize
  # p city.errors unless city.valid?
  p row
  p row[5]
  p row[4]
  p row['08_nom_commune']
  p row['09_codes_postaux']
  p row['11_latitude']
  p row['12_longitude']
  city.update_attributes(
    department_name: row[5],
    department_code: row[4],
    name: row['08_nom_commune'],
    normalized_name: ActiveSupport::Inflector.transliterate(row['08_nom_commune']).parameterize,
    zipcode: row['09_codes_postaux'],
    latitude: row['11_latitude'],
    longitude: row['12_longitude'],
    )
  p city.errors unless city.valid?
end