# frozen_string_literal: true

FactoryBot.define do

  factory :leisure_category do
    sequence(:title) {|n| "Famille loisir #{n}"}
    sequence(:key) {|n| "famille_loisir_#{n}"}
  end
end
