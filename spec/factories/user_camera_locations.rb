# == Schema Information
#
# Table name: user_camera_locations
#
#  id         :integer          not null, primary key
#  latitude   :float
#  longitude  :float
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :user_camera_location do
    latitude 1.5
    longitude 1.5
    user_id 1
  end
end
