# frozen_string_literal: true

FactoryBot.define do

  factory :user do
    firstname "Camille"
    sequence(:lastname) {|n| "Doe#{n}"}
    sequence(:email) {|n| "user#{n}@email.com"}
    phone "#{(0..9).to_a.sample(9)}"
    password "password"
    password_confirmation "password"
    birthdate '1985-03-15'
    sms_notification false
    email_notification true
    city City.first

    leisures{ build_list :leisure, 1 }
  end
end
