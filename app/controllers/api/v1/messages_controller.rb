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
        # converstaion = Conversation.get_conversation(sender,receiver_id)
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
                  "unseen_msgs_count": 0,
                  "sender": {
                      "id": 3,
                      "phone_number": "+923354435636",
                      "pin": "1519",
                      "verified": null,
                      "uuid": "fae0338d-3145-41ad-91b0-43e1d983fe1d",
                      "expires_at": "2017-04-26T07:46:52.821Z",
                      "f_name": null,
                      "l_name": null,
                      "email": null,
                      "notification": true,
                      "created_at": "2017-04-24T06:55:23.355Z",
                      "updated_at": "2017-04-26T07:17:50.464Z",
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
                      "id": 37,
                      "sender_id": 3,
                      "receiver_id": 7,
                      "body": "test notification",
                      "room_id": 1,
                      "created_at": "2017-06-29T16:14:27.031Z",
                      "updated_at": "2017-06-29T16:14:27.031Z",
                      "seen": true
                  }
              },
              {
                  "id": 2,
                  "created_at": "2017-06-23T10:02:59.461Z",
                  "updated_at": "2017-06-23T10:02:59.461Z",
                  "unseen_msgs_count": 2,
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
                  "last_message": {
                      "id": 14,
                      "sender_id": 2,
                      "receiver_id": 2,
                      "body": "message_body_here",
                      "room_id": 2,
                      "created_at": "2017-06-29T11:19:16.640Z",
                      "updated_at": "2017-06-29T11:19:16.640Z",
                      "seen": false
                  }
              },
              {
                  "id": 5,
                  "created_at": "2017-06-29T07:18:33.498Z",
                  "updated_at": "2017-06-29T07:18:33.498Z",
                  "unseen_msgs_count": 0,
                  "sender": null,
                  "receiver": null,
                  "last_message": null
              },
              {
                  "id": 6,
                  "created_at": "2017-06-29T07:19:51.808Z",
                  "updated_at": "2017-06-29T07:19:51.808Z",
                  "unseen_msgs_count": 0,
                  "sender": null,
                  "receiver": null,
                  "last_message": null
              },
              {
                  "id": 7,
                  "created_at": "2017-06-29T07:20:24.857Z",
                  "updated_at": "2017-06-29T07:20:24.857Z",
                  "unseen_msgs_count": 0,
                  "sender": null,
                  "receiver": null,
                  "last_message": null
              },
              {
                  "id": 8,
                  "created_at": "2017-06-29T07:20:33.168Z",
                  "updated_at": "2017-06-29T07:20:33.168Z",
                  "unseen_msgs_count": 0,
                  "sender": null,
                  "receiver": null,
                  "last_message": null
              },
              {
                  "id": 9,
                  "created_at": "2017-06-29T07:22:14.896Z",
                  "updated_at": "2017-06-29T07:22:14.896Z",
                  "unseen_msgs_count": 0,
                  "sender": null,
                  "receiver": null,
                  "last_message": null
              },
              {
                  "id": 10,
                  "created_at": "2017-06-29T07:22:16.855Z",
                  "updated_at": "2017-06-29T07:22:16.855Z",
                  "unseen_msgs_count": 0,
                  "sender": null,
                  "receiver": null,
                  "last_message": null
              },
              {
                  "id": 11,
                  "created_at": "2017-06-29T07:22:54.972Z",
                  "updated_at": "2017-06-29T07:22:54.972Z",
                  "unseen_msgs_count": 0,
                  "sender": null,
                  "receiver": null,
                  "last_message": null
              },
              {
                  "id": 12,
                  "created_at": "2017-06-29T07:23:00.859Z",
                  "updated_at": "2017-06-29T07:23:00.859Z",
                  "unseen_msgs_count": 0,
                  "sender": null,
                  "receiver": null,
                  "last_message": null
              },
              {
                  "id": 13,
                  "created_at": "2017-06-29T07:24:48.762Z",
                  "updated_at": "2017-06-29T07:24:48.762Z",
                  "unseen_msgs_count": 0,
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
        @rooms = Room.includes(messages: [:sender,:receiver]).where(id: room_ids.uniq).where("messages is not null").order('messages.id desc')
        @rooms_with_no_message = Room.where(id: room_ids.uniq - @rooms.collect(&:id))
        @rooms = @rooms + @rooms_with_no_message
        # binding.pry
        # render json: {success: true,message: "",data: @rooms.as_json(methods: :last_message),status: 200}
        # msg_count = unseen_msgs_count(params[:user_id])
        $user_id = User.find_by_uuid(params[:uuid]).id
        render json: {success: true,message: "",data: @rooms.as_json(methods: [:unseen_msgs_count, :sender, :receiver, :last_message]),status: 200}
      end

      # ---------------------------------------- Room Messages ---------------------------------------------------
      api :POST, '/v1/messages/room_messages', 'Room Messages'
      param :id, Integer, desc: 'Room id',required: true
      param :user_id, Integer, desc: 'User who tap on chat room',required: true
      param :current_page, Integer, desc: 'Pagination: Current Page',required: true
      param :per_page, Integer, desc: 'Pagination: Per Page Limit',required: true

      example <<-EOS
      {
        "success": "true",
        "message": "",
        "data": {
            "id": 1,
            "current_page": 1,
            "next_page": 0,
            "last_page": 1,
            "total_msgs": 6,
            "created_at": "2017-06-22T17:07:58.752Z",
            "updated_at": "2017-06-22T17:07:58.752Z",
            "room_messages": [
                {
                    "id": 72,
                    "sender_id": 2,
                    "receiver_id": 7,
                    "body": "sender:2 to receiver:7",
                    "room_id": 1,
                    "created_at": "2017-07-05T11:10:36.755Z",
                    "updated_at": "2017-07-05T11:10:36.755Z",
                    "seen": true,
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
                        "name": "ali imran",
                        "password_digest": null
                    },
                    "receiver": {
                        "id": 7,
                        "phone_number": "+923437718380",
                        "pin": "4490",
                        "verified": true,
                        "uuid": "5bb0f62e-f8fd-4ad1-844e-ea007805f772",
                        "expires_at": "2017-06-13T09:55:59.652Z",
                        "f_name": "abc",
                        "l_name": "abc",
                        "email": "abc@abc.com",
                        "notification": true,
                        "created_at": "2017-06-13T09:14:21.039Z",
                        "updated_at": "2017-07-14T05:25:03.305Z",
                        "distance": 20,
                        "name": "abc abc",
                        "password_digest": "$2a$10$ZPLS.M0mw/rcMoPIOFxMbOURhM2uIT76GOiRzX0ZTPuWKGP3GjG4q"
                    }
                },
                {
                    "id": 73,
                    "sender_id": 2,
                    "receiver_id": 7,
                    "body": "sender:2 to receiver:7 msg 2",
                    "room_id": 1,
                    "created_at": "2017-07-05T11:12:02.704Z",
                    "updated_at": "2017-07-05T11:12:02.704Z",
                    "seen": true,
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
                        "name": "ali imran",
                        "password_digest": null
                    },
                    "receiver": {
                        "id": 7,
                        "phone_number": "+923437718380",
                        "pin": "4490",
                        "verified": true,
                        "uuid": "5bb0f62e-f8fd-4ad1-844e-ea007805f772",
                        "expires_at": "2017-06-13T09:55:59.652Z",
                        "f_name": "abc",
                        "l_name": "abc",
                        "email": "abc@abc.com",
                        "notification": true,
                        "created_at": "2017-06-13T09:14:21.039Z",
                        "updated_at": "2017-07-14T05:25:03.305Z",
                        "distance": 20,
                        "name": "abc abc",
                        "password_digest": "$2a$10$ZPLS.M0mw/rcMoPIOFxMbOURhM2uIT76GOiRzX0ZTPuWKGP3GjG4q"
                    }
                },
                {
                    "id": 74,
                    "sender_id": 7,
                    "receiver_id": 2,
                    "body": "sender:2 to receiver:7 msg 2",
                    "room_id": 1,
                    "created_at": "2017-07-05T13:15:51.273Z",
                    "updated_at": "2017-07-05T13:15:51.273Z",
                    "seen": false,
                    "sender": {
                        "id": 7,
                        "phone_number": "+923437718380",
                        "pin": "4490",
                        "verified": true,
                        "uuid": "5bb0f62e-f8fd-4ad1-844e-ea007805f772",
                        "expires_at": "2017-06-13T09:55:59.652Z",
                        "f_name": "abc",
                        "l_name": "abc",
                        "email": "abc@abc.com",
                        "notification": true,
                        "created_at": "2017-06-13T09:14:21.039Z",
                        "updated_at": "2017-07-14T05:25:03.305Z",
                        "distance": 20,
                        "name": "abc abc",
                        "password_digest": "$2a$10$ZPLS.M0mw/rcMoPIOFxMbOURhM2uIT76GOiRzX0ZTPuWKGP3GjG4q"
                    },
                    "receiver": {
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
                        "name": "ali imran",
                        "password_digest": null
                    }
                },
                {
                    "id": 75,
                    "sender_id": 7,
                    "receiver_id": 2,
                    "body": "sender:2 to receiver:7 msg 2",
                    "room_id": 1,
                    "created_at": "2017-07-06T06:41:53.510Z",
                    "updated_at": "2017-07-06T06:41:53.510Z",
                    "seen": false,
                    "sender": {
                        "id": 7,
                        "phone_number": "+923437718380",
                        "pin": "4490",
                        "verified": true,
                        "uuid": "5bb0f62e-f8fd-4ad1-844e-ea007805f772",
                        "expires_at": "2017-06-13T09:55:59.652Z",
                        "f_name": "abc",
                        "l_name": "abc",
                        "email": "abc@abc.com",
                        "notification": true,
                        "created_at": "2017-06-13T09:14:21.039Z",
                        "updated_at": "2017-07-14T05:25:03.305Z",
                        "distance": 20,
                        "name": "abc abc",
                        "password_digest": "$2a$10$ZPLS.M0mw/rcMoPIOFxMbOURhM2uIT76GOiRzX0ZTPuWKGP3GjG4q"
                    },
                    "receiver": {
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
                        "name": "ali imran",
                        "password_digest": null
                    }
                },
                {
                    "id": 76,
                    "sender_id": 7,
                    "receiver_id": 2,
                    "body": "test datetime",
                    "room_id": 1,
                    "created_at": "2017-07-06T12:06:36.037Z",
                    "updated_at": "2017-07-06T12:06:36.037Z",
                    "seen": false,
                    "sender": {
                        "id": 7,
                        "phone_number": "+923437718380",
                        "pin": "4490",
                        "verified": true,
                        "uuid": "5bb0f62e-f8fd-4ad1-844e-ea007805f772",
                        "expires_at": "2017-06-13T09:55:59.652Z",
                        "f_name": "abc",
                        "l_name": "abc",
                        "email": "abc@abc.com",
                        "notification": true,
                        "created_at": "2017-06-13T09:14:21.039Z",
                        "updated_at": "2017-07-14T05:25:03.305Z",
                        "distance": 20,
                        "name": "abc abc",
                        "password_digest": "$2a$10$ZPLS.M0mw/rcMoPIOFxMbOURhM2uIT76GOiRzX0ZTPuWKGP3GjG4q"
                    },
                    "receiver": {
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
                        "name": "ali imran",
                        "password_digest": null
                    }
                },
                {
                    "id": 77,
                    "sender_id": 7,
                    "receiver_id": 2,
                    "body": "test datetime",
                    "room_id": 1,
                    "created_at": "2017-07-06T12:08:28.044Z",
                    "updated_at": "2017-07-06T12:08:28.044Z",
                    "seen": false,
                    "sender": {
                        "id": 7,
                        "phone_number": "+923437718380",
                        "pin": "4490",
                        "verified": true,
                        "uuid": "5bb0f62e-f8fd-4ad1-844e-ea007805f772",
                        "expires_at": "2017-06-13T09:55:59.652Z",
                        "f_name": "abc",
                        "l_name": "abc",
                        "email": "abc@abc.com",
                        "notification": true,
                        "created_at": "2017-06-13T09:14:21.039Z",
                        "updated_at": "2017-07-14T05:25:03.305Z",
                        "distance": 20,
                        "name": "abc abc",
                        "password_digest": "$2a$10$ZPLS.M0mw/rcMoPIOFxMbOURhM2uIT76GOiRzX0ZTPuWKGP3GjG4q"
                    },
                    "receiver": {
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
                        "name": "ali imran",
                        "password_digest": null
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
        @room = Room.find(params[:id])
        # room.messages.where(seen: false).update_all(seen: true)
        @room.messages.where(seen: false, receiver_id: params[:user_id]).update_all(seen: true)
        # render json: {success: true,message: "",data: room.as_json(include: {messages: {include: [:sender,:receiver]}}),status: 200}
        $per_page = params[:per_page]
        $current_page = params[:current_page]
        @total_msgs_count = @room.messages.count
        @total_pages = @room.messages.order("messages.created_at").paginate(:page => $current_page, :per_page => $per_page).total_pages
        @current_page = @room.messages.order("messages.created_at").paginate(:page => $current_page, :per_page => $per_page).current_page
        if (@current_page >= @total_pages)
          @next_page = 0
        else
          @next_page = @current_page + 1
        end
        # render json: {success: true,message: "",data: room.as_json(methods: :room_messages),status: 200}
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

