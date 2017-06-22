module Api
  module V1
    class MessagesController < ApplicationController
      skip_before_action :authenticate_request, :only => [:send_message, :chats]

      def send_message
        @room = Room.find(params[:id])
        message = @room.messages.create(sender_id: params[:sender_id, receiver_id: params[:receiver_id]],body: params[:body])
        render json: message.as_json(include: [:sender,:receiver])
      end

      def chats
        room_ids = User.find_by_uuid(params[:uuid]).conversations.map(&:room).map(&:id)
        @rooms = Room.includes(messages: [:sender,:receiver]).where(id: room_ids.uniq)
        render json: @rooms.as_json(methods: :last_message)
      end

      def room_messages
        room = Room.find(params[:id])
        render json: room.as_json(include: {messages: {include: [:sender,:receiver]}})
      end

    end
  end
end

