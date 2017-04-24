# FactoryGirl.define do
#   factory :device do
#     device_token { Faker::Crypto.sha256 }
#     device_type { Faker::Lorem.word }
#     user_id { Faker::Number.between(1, 10) }
#   end
# end