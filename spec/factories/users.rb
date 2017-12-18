# frozen_string_literal: true

FactoryBot.define do

  factory :user do
    firstname "Camille"
    sequence(:lastname) {|n| "Doe#{n}"}
    sequence(:email) {|n| "user#{n}@email.com"}
    password "password"
    password_confirmation "password"
  end
end
