# frozen_string_literal: true

FactoryBot.define do

  factory :city do
    department_name "Vosges"
    department_code "88"
    sequence(:name) {|n| "Ville#{n}"}
    sequence(:normalized_name) {|n| "ville#{n}"}
    zipcode "88000"
    insee "88160"
    latitude 0.48183333e2
    longitude 0.645e1

  end
end
