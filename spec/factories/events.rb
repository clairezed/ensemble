# frozen_string_literal: true

FactoryBot.define do

  factory :event do
    sequence(:title) {|n| "event#{n}"}
    start_at Date.current+1.month
    end_at Date.current+1.month+2.day
    association :country
    association :leisure_category
    association :user
  end
end
