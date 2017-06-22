module Api
  module V1
    class MessagesController < ApplicationController
      skip_before_action :authenticate_request, :only => [:send_message, :chats, :room_messages]

      # ---------------------------------------- Send Message ---------------------------------------------------
      api :POST, '/v1/messages/send_message', 'Send Message'
      param :id, Integer, desc: 'Room id',required: true
      param :sender_id, Integer, desc: 'Sender ID',required: true
      param :receiver_id, Integer, desc: 'Receiver ID',required: true
      param :body, String, desc: 'Message Body',required: true


      example <<-EOS
      {
        "id": 1,
        "sender_id": 2,
        "receiver_id": 7,
        "body": "Hello how are you?",
        "room_id": 1,
        "created_at": "2017-06-22T17:08:36.667Z",
        "updated_at": "2017-06-22T17:08:36.667Z",
        "sender": {
            "id": 2,
            "phone_number": "+923219346933",
            "pin": "3389",
            "verified": true,
            "uuid": "64f0e0c5-20f4-4071-a31b-e0b8ca69a938",
            "expires_at": "2017-06-19T07:15:34.135Z",
            "f_name": "ali",
            "l_name": "imran",
            "email": "example@mail.com",
            "notification": false,
            "created_at": "2017-04-21T08:12:11.358Z",
            "updated_at": "2017-06-19T06:46:17.737Z",
            "distance": 20,
            "name": null,
            "password_digest": null
        },
        "receiver": {
            "id": 7,
            "phone_number": "+923219346931",
            "pin": "4490",
            "verified": null,
            "uuid": "5bb0f62e-f8fd-4ad1-844e-ea007805f772",
            "expires_at": "2017-06-13T09:55:59.652Z",
            "f_name": null,
            "l_name": null,
            "email": "example+1@mail.com",
            "notification": true,
            "created_at": "2017-06-13T09:14:21.039Z",
            "updated_at": "2017-06-13T09:25:59.653Z",
            "distance": 20,
            "name": null,
            "password_digest": "$2a$10$ZPLS.M0mw/rcMoPIOFxMbOURhM2uIT76GOiRzX0ZTPuWKGP3GjG4q"
        }
      }
      EOS
      def send_message
        @room = Room.find(params[:id])
        message = @room.messages.create(sender_id: params[:sender_id], receiver_id: params[:receiver_id],body: params[:body])
        render json: message.as_json(include: [:sender,:receiver])
      end

      # ---------------------------------------- User Chats ---------------------------------------------------
      api :POST, '/v1/messages/chats', 'User Chats with last message'
      param :uuid, String, desc: 'User UUID',required: true
      example <<-EOS
      [
          {
              "id": 2,
              "created_at": "2017-06-22T12:04:28.104Z",
              "updated_at": "2017-06-22T12:04:28.104Z",
              "last_message": {
                  "id": 1,
                  "sender_id": 2,
                  "receiver_id": 7,
                  "body": "Sent to 7",
                  "room_id": 2,
                  "created_at": "2017-06-22T12:06:21.677Z",
                  "updated_at": "2017-06-22T12:06:21.677Z",
                  "sender": {
                      "id": 2,
                      "phone_number": "+923219346933",
                      "pin": "3389",
                      "verified": true,
                      "uuid": "64f0e0c5-20f4-4071-a31b-e0b8ca69a938",
                      "expires_at": "2017-06-19T07:15:34.135Z",
                      "f_name": "ali",
                      "l_name": "imran",
                      "email": "example@mail.com",
                      "notification": false,
                      "created_at": "2017-04-21T08:12:11.358Z",
                      "updated_at": "2017-06-19T06:46:17.737Z",
                      "distance": 20,
                      "name": null,
                      "password_digest": null
                  },
                  "receiver": {
                      "id": 7,
                      "phone_number": "+923219346931",
                      "pin": "4490",
                      "verified": null,
                      "uuid": "5bb0f62e-f8fd-4ad1-844e-ea007805f772",
                      "expires_at": "2017-06-13T09:55:59.652Z",
                      "f_name": null,
                      "l_name": null,
                      "email": "example+1@mail.com",
                      "notification": true,
                      "created_at": "2017-06-13T09:14:21.039Z",
                      "updated_at": "2017-06-13T09:25:59.653Z",
                      "distance": 20,
                      "name": null,
                      "password_digest": "$2a$10$ZPLS.M0mw/rcMoPIOFxMbOURhM2uIT76GOiRzX0ZTPuWKGP3GjG4q"
                  }
              }
          }
      ]
      EOS

      def chats
        room_ids = User.find_by_uuid(params[:uuid]).conversations.map(&:room).map(&:id)
        @rooms = Room.includes(messages: [:sender,:receiver]).where(id: room_ids.uniq)
        render json: @rooms.as_json(methods: :last_message)
      end

      # ---------------------------------------- Room Messages ---------------------------------------------------
      api :POST, '/v1/messages/room_messages', 'Room Messages'
      param :id, Integer, desc: 'Room id',required: true
      example <<-EOS
      {
          "id": 2,
          "created_at": "2017-06-22T12:04:28.104Z",
          "updated_at": "2017-06-22T12:04:28.104Z",
          "messages": [
              {
                  "id": 1,
                  "sender_id": 2,
                  "receiver_id": 7,
                  "body": "Sent to 7",
                  "room_id": 2,
                  "created_at": "2017-06-22T12:06:21.677Z",
                  "updated_at": "2017-06-22T12:06:21.677Z",
                  "sender": {
                      "id": 2,
                      "phone_number": "+923219346933",
                      "pin": "3389",
                      "verified": true,
                      "uuid": "64f0e0c5-20f4-4071-a31b-e0b8ca69a938",
                      "expires_at": "2017-06-19T07:15:34.135Z",
                      "f_name": "ali",
                      "l_name": "imran",
                      "email": "example@mail.com",
                      "notification": false,
                      "created_at": "2017-04-21T08:12:11.358Z",
                      "updated_at": "2017-06-19T06:46:17.737Z",
                      "distance": 20,
                      "name": null,
                      "password_digest": null
                  },
                  "receiver": {
                      "id": 7,
                      "phone_number": "+923219346931",
                      "pin": "4490",
                      "verified": null,
                      "uuid": "5bb0f62e-f8fd-4ad1-844e-ea007805f772",
                      "expires_at": "2017-06-13T09:55:59.652Z",
                      "f_name": null,
                      "l_name": null,
                      "email": "example+1@mail.com",
                      "notification": true,
                      "created_at": "2017-06-13T09:14:21.039Z",
                      "updated_at": "2017-06-13T09:25:59.653Z",
                      "distance": 20,
                      "name": null,
                      "password_digest": "$2a$10$ZPLS.M0mw/rcMoPIOFxMbOURhM2uIT76GOiRzX0ZTPuWKGP3GjG4q"
                  }
              }
          ]
      }
      EOS

      def room_messages
        room = Room.find(params[:id])
        render json: room.as_json(include: {messages: {include: [:sender,:receiver]}})
      end

      # ---------------------------------------- Create Conversation ---------------------------------------------------
      api :POST, '/v1/messages/room', 'Create Conversation'
      param :phone_number, String, desc: 'Receiver Phone Number with proper format (i.e. +923211111111)',required: true
      param :uuid, String, desc: 'Logged in User uuid',required: true
      example <<-EOS
      {
        "room_id": 1
      }
      EOS
      description <<-EOS
        == Append room-
         room id is returned in json, you have to append room-.
      EOS
      def room
        user = User.find_by_phone_number(params[:phone_number])
        logged_in_user = User.find_by_uuid(params[:uuid])
        conversation = Conversation.get_conversation(logged_in_user,user.id)
        render json: {
                   room_id: conversation.room_id
               }
      end

    end
  end
end

