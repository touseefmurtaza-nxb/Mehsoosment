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
  has_many :messages, dependent: :destroy

  def last_message
    # messages.last.as_json(include: [:sender,:receiver])
    messages.last.as_json()
  end

  def sender
    messages.try(:last).try(:sender).try(:as_json)
  end

  def receiver
    messages.try(:last).try(:receiver ).try(:as_json)
  end

  def unseen_msgs_count
    messages.where(seen: false).count
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
