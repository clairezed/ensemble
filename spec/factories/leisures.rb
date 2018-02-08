# frozen_string_literal: true

FactoryBot.define do

  factory :leisure do
    sequence(:title) {|n| "Loisir #{n}"}
    sequence(:key) {|n| "loisir_#{n}"}
    association :leisure_category
  end
end
