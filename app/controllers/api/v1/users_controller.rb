module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authenticate_request, :only => [:create, :verify]
      include UsersHelper

      # ---------------------------------------- User Registration Through Phone Number --------------------------------
      api :POST, '/v1/users', 'Register User'
      param :phone_number, String, desc: 'User phone number to register with', required: true
      param :email, String, desc: 'User Email', required: true
      param :password, String, desc: 'User Password', required: true
      example <<-EOS
      {
          "success": "true",
          "message": "",
          "data": {
              "uuid": "64f0e0c5-20f4-4071-a31b-e0b8ca69a938"
          },
          "status": 200
      }
      EOS
      def create
        if params[:phone_number].present?
          phone_number = number = number_format(params[:phone_number])
          @user = User.find_or_create_by(phone_number: phone_number)
          # unless @user
          #   @user = User.create!(phone_number: phone_number, email: params[:email], password: params[:password], password_confirmation: params[:password])
          # end
          user_registration(@user) unless Rails.env == "test"
          if @user
            render :json => {success:"true", message:"", data:{uuid:@user.uuid}, status:200}
          else
            render :json => {success:"false", message:"", data:{}, status:400}
          end
        else
          render :json => {success:"false", message:"", data:{}, status:400}
        end
      end

      # ---------------------------------------- User Verification Through UUID and User Pin ---------------------------
      api :POST, '/v1/users/verify', 'Verify user through pin code'
      param :uuid, String, desc: 'User uuid sent in response to success registration', required: true
      param :pin, String, desc: 'User pin sent to user mobile while registration', required: true
      example <<-EOS
      {
          "success": "true",
          "message": "",
          "data": {
              "auth_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJleHAiOjE0OTc0NDIwMjJ9.KvFmFbUlEU9yoUG_8NZt9xXxbg4WU2CUpFnj3Cyw6Xs",
              "user_id": 2,
              "phone_number": "+923219346933",
              "first_name": "ali",
              "last_name": "imran",
              "email": "touseef.murtaza@nxb.com.pk",
              "notification": false
          },
          "status": 200
      }
      EOS
      def verify
        @user = User.find_by(uuid: params[:uuid])
        command = AuthenticateUser.call(params[:uuid], params[:pin])
        if command.success?
          auth_token = command.result
        else
          render json: { error: command.errors }, status: :unauthorized
        end
        if @user
          user_verification(@user)
          if ((@user.verified?) and (!@user.expired?))
            render :json => {
                       success:"true",
                       message:"",
                       data:
                       {  
                          auth_token:auth_token,
                          user_id:@user.id,
                          phone_number:@user.phone_number,
                          first_name:@user.f_name,
                          last_name:@user.l_name,
                          email:@user.email,
                          notification:@user.notification,
                       },
                       status:200
                      }
          elsif @user.expired?
            render :json => {
                        success:"false",
                        message:"PIN Expired",
                        data:{},
                        status:400
                      }
          else
            render :json => {
                       success:"false",
                       message:"Invalid PIN",
                       data:{},
                       status:400
                      }
          end
        else
          render :json => {
                     success:"false",
                     message:"",
                     data:{},
                     status:400
                    }
        end
      end

      # ---------------------------------------- Update User Setting ---------------------------------------------------
      api :POST, '/v1/users/update', 'Update user settings'
      param :f_name, String, desc: 'User first name'
      param :l_name, String, desc: 'User last name'
      param :email, String, desc: 'User email'
      param :notification, :bool, desc: 'User will either receive notification or not (Boolean Value)'
      param :user_id, Integer, desc: 'User id whose settings are going to change', required: true
      example <<-EOS
      {
          "success": "true",
          "message": "User Setting Updated",
          "data": {
              "user_id": 2,
              "phone_number": "+923219346933",
              "first_name": "ali",
              "last_name": "imran",
              "email": "example@mail.com",
              "notification": false
          },
          "status": 200
      }
      EOS
      def update_user
        @user = User.where(id: params[:user_id]).first
        unless @user.nil?
          if @user.update(user_params)
            render :json => {
                       success:"true",
                       message:"User Setting Updated",
                       data:
                           {  user_id: @user.id,
                              phone_number: @user.phone_number,
                              first_name: @user.f_name,
                              last_name: @user.l_name,
                              email: @user.email,
                              notification: @user.notification
                           },
                       status:200
                      }
          else
            render :json => {
                       success:"false",
                       message:"",
                       data:{},
                       status:400
                      }
          end
        else
          render :json => {
                     success:"false",
                     message:"",
                     data:{},
                     status:404
                    }
        end
      end

      # ---------------------------------------- Fetch users already using Mehsoosment App ---------------------------------------------------
      api :POST, '/v1/users/registered_contacts', 'Fetch users already using Mehsoosment App'
      param "contacts", Array, desc: 'Contact List with Name and Number like contacts = [{contactName:"Khawar", phoneNumbers:["+923041758416", "03004455990"]}]', required: true
      param "uuid", String, desc: 'User uuid', required: true
      example <<-EOS
      {
          "success": "true",
          "message": "",
          "data": {
              "registered_users": [
                  {
                      "contactName": "Abubaker",
                      "phoneNumber": "+923219346933"
                  }
              ]
          },
          "status": 200
      }
      EOS

      def get_registered_contacts
        hsh = {}
        arr = []
        user = User.find_by(uuid: params[:uuid])
        own_number = user.phone_number
        contacts = JSON.parse params[:contacts]
        verified_users = User.verified.pluck(:phone_number)
        contacts.each do |contact|
          contact["phoneNumbers"].each do |number|
            number = number_format(number)
            if verified_users.include? number and (own_number != number)
              hsh[:contactName] = contact["contactName"]
              hsh[:phoneNumber] = number
              arr << hsh
            end
          end
        end
        render :json => {
                   success:"true",
                   message:"",
                   data:{:registered_users=> arr},
                   status:200
               }
      end

      private
      def user_params
        params.permit(:f_name, :l_name, :email, :distance, :notification)
      end
      def device_params
        params.permit(:device_token, :device_type, :user_id)
      end
      def number_format number
        if number[0] == "0"
          number = number.sub(/^./, '+92')
        end
        return number
      end
    end
  end
end
