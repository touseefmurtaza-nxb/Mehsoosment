FactoryGirl.define do
  factory :user do
    phone_number { "+923" + Faker::Number.number(9) }
    pin { Faker::Number.number(4) }
    verified { Faker::Boolean.boolean }
    uuid { SecureRandom.uuid }
    expires_at { (Time.zone.now + 30.minutes) }
    f_name { Faker::Name.first_name }
    l_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    notification { Faker::Boolean.boolean }
  end
end