# == Schema Information
#
# Table name: conversations
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  room_id       :integer
#  connection_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryGirl.define do
  factory :conversation do
    user_id 1
    room_id 1
  end
end
