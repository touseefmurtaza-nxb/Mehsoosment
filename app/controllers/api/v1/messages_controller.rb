module Api
  module V1
    class MessagesController < ApplicationController
      # skip_before_action :authenticate_request, :only => [:send_message, :chats, :room_messages]

      # ---------------------------------------- Send Message ---------------------------------------------------
      api :POST, '/v1/messages/send_message', 'Send Message'
      param :id, Integer, desc: 'Room id',required: true
      param :uuid, String, desc: 'Sender uuid',required: true
      param :body, String, desc: 'Message Body',required: true


      example <<-EOS
      {
        "success": true,
        "message": "",
        "data": {
            "id": 15,
            "sender_id": 2,
            "receiver_id": 7,
            "body": "message_body_here",
            "room_id": 1,
            "created_at": "2017-06-29T11:19:24.134Z",
            "updated_at": "2017-06-29T11:19:24.134Z",
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
        },
        "status": 200
      }
      EOS
      description <<-EOS
        == Authentication required
         Authentication token has to be passed as part of the request. It can be passed as parameter in HTTP header(Authorization).
      EOS
      def send_message
        sender_id,receiver_id,room = Room.get_sender_receiver_id(params[:uuid],params[:id])
        message = room.messages.create(sender_id: sender_id, receiver_id: receiver_id,body: params[:body])
        render json: {success: true,message: "",data: message.as_json(include: [:sender,:receiver]),status: 200}
        # render json: {success: true,message: "",data: message.as_json,status: 200}
      end

      # ---------------------------------------- User Chats ---------------------------------------------------
      api :POST, '/v1/messages/chats', 'User Chats with last message'
      param :uuid, String, desc: 'User UUID',required: true
      example <<-EOS
      {
        "success": true,
        "message": "",
        "data": [
            {
                "id": 1,
                "created_at": "2017-06-22T17:07:58.752Z",
                "updated_at": "2017-06-22T17:07:58.752Z",
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
                },
                "last_message": {
                    "id": 11,
                    "sender_id": 2,
                    "receiver_id": 7,
                    "body": "message_body_here",
                    "room_id": 1,
                    "created_at": "2017-06-29T09:45:33.817Z",
                    "updated_at": "2017-06-29T09:45:33.817Z"
                }
            },
            {
                "id": 2,
                "created_at": "2017-06-23T10:02:59.461Z",
                "updated_at": "2017-06-23T10:02:59.461Z",
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
                },
                "last_message": {
                    "id": 8,
                    "sender_id": 2,
                    "receiver_id": 7,
                    "body": "test messages",
                    "room_id": 2,
                    "created_at": "2017-06-29T08:20:16.192Z",
                    "updated_at": "2017-06-29T08:20:16.192Z"
                }
            },
            {
                "id": 5,
                "created_at": "2017-06-29T07:18:33.498Z",
                "updated_at": "2017-06-29T07:18:33.498Z",
                "sender": null,
                "receiver": null,
                "last_message": null
            },
            {
                "id": 6,
                "created_at": "2017-06-29T07:19:51.808Z",
                "updated_at": "2017-06-29T07:19:51.808Z",
                "sender": null,
                "receiver": null,
                "last_message": null
            },
            {
                "id": 7,
                "created_at": "2017-06-29T07:20:24.857Z",
                "updated_at": "2017-06-29T07:20:24.857Z",
                "sender": null,
                "receiver": null,
                "last_message": null
            }
        ],
        "status": 200
      }
      EOS
      description <<-EOS
        == Authentication required
         Authentication token has to be passed as part of the request. It can be passed as parameter in HTTP header(Authorization).
      EOS

      def chats
        room_ids = User.find_by_uuid(params[:uuid]).conversations.map(&:room).compact.map(&:id)
        @rooms = Room.includes(messages: [:sender,:receiver]).where(id: room_ids.uniq)
        # render json: {success: true,message: "",data: @rooms.as_json(methods: :last_message),status: 200}
        render json: {success: true,message: "",data: @rooms.as_json(methods: [:sender, :receiver, :last_message]),status: 200}
      end

      # ---------------------------------------- Room Messages ---------------------------------------------------
      api :POST, '/v1/messages/room_messages', 'Room Messages'
      param :id, Integer, desc: 'Room id',required: true
      example <<-EOS
      {
        "success": true,
        "message": "",
        "data": {
            "id": 2,
            "created_at": "2017-06-23T10:02:59.461Z",
            "updated_at": "2017-06-23T10:02:59.461Z",
            "messages": [
                {
                    "id": 8,
                    "sender_id": 2,
                    "receiver_id": 7,
                    "body": "test messages",
                    "room_id": 2,
                    "created_at": "2017-06-29T08:20:16.192Z",
                    "updated_at": "2017-06-29T08:20:16.192Z",
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
        },
        "status": 200
      }
      EOS
      description <<-EOS
        == Authentication required
         Authentication token has to be passed as part of the request. It can be passed as parameter in HTTP header(Authorization).
      EOS

      def room_messages
        room = Room.find(params[:id])
        render json: {success: true,message: "",data: room.as_json(include: {messages: {include: [:sender,:receiver]}}),status: 200}
      end

      # ---------------------------------------- Create Conversation ---------------------------------------------------
      api :POST, '/v1/messages/room', 'Create Conversation'
      param :phone_number, String, desc: 'Receiver Phone Number with proper format (i.e. +923211111111)',required: true
      param :uuid, String, desc: 'Logged in User uuid',required: true
      example <<-EOS
      {
          "success": true,
          "message": "",
          "data": {
              "id": 2,
              "created_at": "2017-06-23T10:02:59.461Z",
              "updated_at": "2017-06-23T10:02:59.461Z",
              "messages": []
          },
          "status": 200
      }
      EOS
      description <<-EOS
        == Authentication required
         Authentication token has to be passed as part of the request. It can be passed as parameter in HTTP header(Authorization).
      EOS
      def room
        user = User.find_by_phone_number(params[:phone_number])
        logged_in_user = User.find_by_uuid(params[:uuid])
        conversation = Conversation.get_conversation(logged_in_user,user.id)
        render json: {success: true,message: "",data: conversation.room.as_json(include: {messages: {include: [:sender,:receiver]}}),status: 200}
      end

      # ---------------------------------------- Delete Conversation ---------------------------------------------------
      api :DELETE, '/v1/messages/destroy_room', 'Delete Conversation'
      param :room_id, Integer, desc: 'Room ID',required: true
      example <<-EOS
      {
          "success": true,
          "message": "Room Deleted",
          "data": "",
          "status": 200
      }
      EOS
      description <<-EOS
        == Authentication required
         Authentication token has to be passed as part of the request. It can be passed as parameter in HTTP header(Authorization).
      EOS

      def destroy_room
        room = Room.find(params[:room_id])
        if room
          if room.destroy!
            render json: {success: true,message: "Room Deleted",data: "",status: 200}
          end
        end
      end

    end
  end
end

