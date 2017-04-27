FactoryGirl.define do
  factory :user_location do
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    user_id { Faker::Number.between(1, 10) }
  end
end