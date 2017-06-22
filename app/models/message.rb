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
#

class Message < ApplicationRecord

  belongs_to :room

  belongs_to :sender, class_name: User.name
  belongs_to :receiver, class_name: User.name

  after_create :broadcast_message

  def broadcast_message
    $redis.publish 'message', {room: "room-#{room_id}", id: self.id, sender_id: self.sender_id, receiver_id: self.receiver_id, body: self.body, created_at: self.created_at}.to_json
  end

end
