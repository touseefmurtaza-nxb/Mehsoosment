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
          user_registration(@user)
          if @user
            render :json => {success:"true", message:"", data:{uuid:@user.uuid}, status:200}
          else
            render :json => {success:"false", message:"", data:{}, status:400}
          end
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
        @user = User.find(params[:user_id])
        (@user.update(user_params)) ? (@update = true) : (@update = false)
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
