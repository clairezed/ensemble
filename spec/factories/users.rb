# frozen_string_literal: true

FactoryBot.define do

  factory :user do
    firstname "Camille"
    sequence(:lastname) {|n| "Doe#{n}"}
    sequence(:email) {|n| "user#{n}@email.com"}
    sequence(:phone) {|n| "6#{n}00000000"[0..8]}
    # phone "#{(0..9).to_a.sample(9).join('')}"
    gender 'female'
    password "password"
    password_confirmation "password"
    birthdate '1985-03-15'
    sms_notification false
    email_notification true
    association :city

    leisures{ build_list :leisure, 1 }

    trait :registration_complete do
      registration_complete true
      sms_confirmation_sent_at Time.current
    end

    trait :admin_accepted do
      registration_complete true
      verification_state :admin_accepted
      sms_confirmed_at Time.current
      confirmed_at Time.current
    end

  end
end
