# == Schema Information
#
# Table name: mark_dangers
#
#  id         :integer          not null, primary key
#  latitude   :float
#  longitude  :float
#  user_id    :integer
#  mark_type  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :mark_danger do
    latitude 1.5
    longitude 1.5
    user_id 1
    mark_type 1
  end
end
