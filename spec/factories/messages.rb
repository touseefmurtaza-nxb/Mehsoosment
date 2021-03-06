# == Schema Information
#
# Table name: messages
#
#  id          :integer          not null, primary key
#  sender_id   :integer
#  receiver_id :integer
#  body        :string
#  room_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  seen        :boolean          default("false")
#

FactoryGirl.define do
  factory :message do
    sender_id 1
    receiver_id 1
    body "MyText"
    room_id 1
  end
end
