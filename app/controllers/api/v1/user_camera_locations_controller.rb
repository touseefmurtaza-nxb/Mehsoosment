module Api
  module V1
    class UserCameraLocationsController < ApplicationController
      include UserLocationsHelper

      # ---------------------------------------- Save User Current Location and return nearby Danger markups -----------
      api :POST, '/v1/user_camera_locations', 'Update user location'
      param :latitude, Float, desc: 'User current location latitude', required: true
      param :longitude, Float, desc: 'User current location longitude', required: true
      param :user_id, Integer, desc: 'User id, whose current location is marked', required: true
      def create
        @location = UserCameraLocation.new(latitude: params[:latitude], longitude: params[:longitude], user_id: params[:user_id])
        if @location.save
          if @location.user.distance.nil?
            distance = 20.0
          else
            distance = @location.user.distance
          end
          @markups = MarkDanger.near([@location.latitude,@location.longitude],distance)
          send_notification(@markups)
        end
      end

    end
  end
end