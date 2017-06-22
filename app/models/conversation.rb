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

class Conversation < ApplicationRecord
  belongs_to :user
  belongs_to :connection,class_name: User.name
  belongs_to :room

  class << self

    def create_chat_room(user,connection_id)
      conversation = user.conversations.create(connection_id: connection_id)
      room = conversation.create_room
      conversation.room_id = room.id
      conversation.save
      conversation.create_reverse_connection(room)
    end

  end


  def create_reverse_connection(room)
    Conversation.create(user_id: connection_id,connection_id: user_id,room_id: room.id)
  end


end
