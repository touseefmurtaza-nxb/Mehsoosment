module Api
  module V1
    class UsersController < ApplicationController
      include UsersHelper

      # ---------------------------------------- User Registration Through Phone Number --------------------------------
      api :POST, '/v1/users', 'Register User'
      param :phone_number, String, desc: 'User phone number to register with', required: true
      def create
        if params[:phone_number].present?
          phone_number = params[:phone_number].sub(/^./, '+92')
          @user = User.find_or_create_by(phone_number: phone_number)
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

      def verify
        @user = User.find_by(uuid: params[:uuid])
        if @user
          user_verification(@user)
          if ((@user.verified?) and (!@user.expired?))
            render :json => {
                       success:"true",
                       message:"",
                       data:
                       {  user_id:@user.id,
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

      def get_registered_contacts
        hsh = {}
        arr = []
        contacts = JSON.parse params[:contacts]
        verified_users = User.verified.pluck(:phone_number)
        contacts.each do |contact|
          contact["phoneNumbers"].each do |number|
            if number[0] == "0"
              number = number.sub(/^./, '+92')
            end
            if verified_users.include? number
              hsh[:contactName] = contact[:contactName]
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
    end
  end
end
