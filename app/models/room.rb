# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Room < ApplicationRecord
  has_many :conversations
  has_many :messages

  def last_message
    messages.last.as_json(include: [:sender,:receiver])
  end

  class << self

    def get_sender_receiver_id(uuid,room_id)
      room = Room.find(room_id)
      conversation = room.conversations.first
      sender = User.find_by_uuid(uuid)
      receiver_id = (conversation.user_id == sender.id) ? conversation.connection_id : conversation.user_id
      [sender.id,receiver_id,room]
    end

  end

end
