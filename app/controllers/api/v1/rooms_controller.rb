module Api
  module V1
    class RoomsController < ApplicationController
    before_action :room_param

      # ---------------------------------------- Set Messages Seen ---------------------------------------------------
      api :POST, '/v1/rooms/read_messages', 'Set Room Messages to Seen'
      param :id, Integer, desc: 'Room id',required: true
      param :user_id, Integer, desc: 'User who tap on chat room',required: true

      example <<-EOS
      {
        "success": true,
        "messgae": "Messages Seen",
        "data": "",
        "status": 200
      }
      EOS
      description <<-EOS
        == Authentication required
         Authentication token has to be passed as part of the request. It can be passed as parameter in HTTP header(Authorization).
      EOS
      def read_messages
        @room.messages.where(seen: false, receiver_id: params[:user_id]).update_all(seen: true)
        render json: {success: true, messgae: "Messages Seen", data: "", status: 200}
      end

      # ---------------------------------------- Get All Unseen Messages of a Room ---------------------------------------------------
      api :POST, '/v1/rooms/unseen_messages', 'Get All Unseen Messages of a Room'
      param :id, Integer, desc: 'Room id',required: true

      example <<-EOS
      {
        "success": true,
        "messgae": "",
        "data": {
            "unseen_msgs_count": 4
        },
        "status": 200
      }
      EOS
      description <<-EOS
        == Authentication required
         Authentication token has to be passed as part of the request. It can be passed as parameter in HTTP header(Authorization).
      EOS
      def unseen_messages
        unseen_msgs = @room.messages.where(seen: false, receiver_id: params[:user_id])
        render json: {success: true, messgae: "", data: {unseen_msgs_count: unseen_msgs.count}.as_json, status: 200}
      end

      # ---------------------------------------- Reset Message Counter While Leaving Room ---------------------------------------------------
      api :POST, '/v1/rooms/leave_room', 'Reset Message Counter While Leaving Room'
      param :id, Integer, desc: 'Room id',required: true
      param :user_id, Integer, desc: 'User who leave the chat room',required: true

      example <<-EOS
      {
        "success": true,
        "messgae": "Messages Counter Reset",
        "data": "",
        "status": 200
      }
      EOS
      description <<-EOS
        == Authentication required
         Authentication token has to be passed as part of the request. It can be passed as parameter in HTTP header(Authorization).
      EOS
      def leave_room
        @room.messages.where(seen: false, receiver_id: params[:user_id]).update_all(seen: true)
        # @room.messages.where("messages.seen = ? AND (messages.receiver_id = ? OR messages.sender_id = ?)", false, params[:user_id], params[:user_id]).update_all(seen: true)
        render json: {success: true, messgae: "Messages Counter Reset", data: "", status: 200}
      end

      private
      def room_param
        @room = Room.find(params[:id])
      end

    end
  end
end

