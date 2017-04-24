module Api
  module V1
    module UsersHelper

      def user_registration(user)
        user.generate_pin
        user.send_pin
      end

      def user_verification(user)
        user.verify(params[:pin])
        if user.device.nil?
          Device.create(:device_token => params[:device_token], :device_type => params[:device_type], :user_id => user.id)
        elsif (params[:device_token].present? and params[:device_type].present?)
          user.device.update(:device_token => params[:device_token], :device_type => params[:device_type])
        end
      end

    end
  end
end