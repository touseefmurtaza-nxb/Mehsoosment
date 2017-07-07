module Api
  module V1
    class UserCameraLocationsController < ApplicationController
      include UserLocationsHelper

      # ---------------------------------------- Save User Current Location and return nearby Danger markups -----------
      api :POST, '/v1/user_camera_locations', 'Update user location'
      param :latitude, Float, desc: 'User current location latitude', required: true
      param :longitude, Float, desc: 'User current location longitude', required: true
      param :user_id, Integer, desc: 'User id, whose current location is marked', required: true
      example <<-EOS
      {
          "success": "true",
          "message": "Location Saved",
          "data": {
              "alert": "You are on Challan place.",
              "markers": [
                  {
                      "id": 19,
                      "latitude": 33.253235541,
                      "longitude": 74.27327282603,
                      "user_id": 2,
                      "mark_type": 4,
                      "created_at": "23 days ago",
                      "updated_at": "2017-06-14T09:41:29.702Z",
                      "distance": 0,
                      "bearing": "0.0",
                      "user_status": {
                          "status_id": 26,
                          "status_text": "Hello, How You Doing?",
                          "image_url": "mehsoosment.vteamslabs.com/system/statuses/images/000/000/026/original/20170616_110750.jpg?1498123121"
                      }
                  },
                  {
                      "id": 18,
                      "latitude": 33.253235541,
                      "longitude": 74.27327282603,
                      "user_id": 2,
                      "mark_type": 4,
                      "created_at": "23 days ago",
                      "updated_at": "2017-06-13T12:22:55.540Z",
                      "distance": 0,
                      "bearing": "0.0",
                      "user_status": {
                          "status_id": 26,
                          "status_text": "Hello, How You Doing?",
                          "image_url": "mehsoosment.vteamslabs.com/system/statuses/images/000/000/026/original/20170616_110750.jpg?1498123121"
                      }
                  },
                  {
                      "id": 17,
                      "latitude": 33.253235541,
                      "longitude": 74.27327282603,
                      "user_id": 2,
                      "mark_type": 4,
                      "created_at": "23 days ago",
                      "updated_at": "2017-06-13T12:06:24.180Z",
                      "distance": 0,
                      "bearing": "0.0",
                      "user_status": {
                          "status_id": 26,
                          "status_text": "Hello, How You Doing?",
                          "image_url": "mehsoosment.vteamslabs.com/system/statuses/images/000/000/026/original/20170616_110750.jpg?1498123121"
                      }
                  }
              ]
          }
      }
      EOS
      description <<-EOS
        == Authentication required
         Authentication token has to be passed as part of the request. It can be passed as parameter in HTTP header(Authorization).
      EOS
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