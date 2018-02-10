FactoryBot.define do

  factory :event_participation do
    association :event
    association :user
  end
end