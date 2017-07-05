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
    messages.order("messages.created_at").last.as_json()
  end

  def sender
    messages.order(id: :asc).try(:last).try(:sender).try(:as_json)
  end

  def receiver
    messages.order(id: :asc).try(:last).try(:receiver ).try(:as_json)
  end

  def unseen_msgs_count
    # messages.where(seen: false).count
    messages.where(seen: false, receiver_id: $user_id).count
  end

  def room_messages
    messages.order("messages.created_at").as_json(include: [:sender, :receiver])
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
