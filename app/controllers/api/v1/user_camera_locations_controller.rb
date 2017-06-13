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
                    "id": 4,
                    "latitude": 33.253235541,
                    "longitude": 74.27327282603,
                    "user_id": 3,
                    "mark_type": 2,
                    "created_at": "2017-06-12T06:44:18.232Z",
                    "updated_at": "2017-06-13T12:26:48.382Z",
                    "distance": 0,
                    "bearing": "0.0"
                },
                {
                    "id": 7,
                    "latitude": 33.253235541,
                    "longitude": 74.27327282603,
                    "user_id": 2,
                    "mark_type": null,
                    "created_at": "2017-06-12T06:46:05.304Z",
                    "updated_at": "2017-06-12T06:46:05.304Z",
                    "distance": 0,
                    "bearing": "0.0"
                },
                {
                    "id": 13,
                    "latitude": 33.253235541,
                    "longitude": 74.27327282603,
                    "user_id": 2,
                    "mark_type": 4,
                    "created_at": "2017-06-13T11:45:30.181Z",
                    "updated_at": "2017-06-13T11:45:30.181Z",
                    "distance": 0,
                    "bearing": "0.0"
                },
                {
                    "id": 14,
                    "latitude": 33.253235541,
                    "longitude": 74.27327282603,
                    "user_id": 2,
                    "mark_type": 4,
                    "created_at": "2017-06-13T11:45:36.140Z",
                    "updated_at": "2017-06-13T11:45:36.140Z",
                    "distance": 0,
                    "bearing": "0.0"
                },
                {
                    "id": 15,
                    "latitude": 33.253235541,
                    "longitude": 74.27327282603,
                    "user_id": 2,
                    "mark_type": 4,
                    "created_at": "2017-06-13T11:45:41.019Z",
                    "updated_at": "2017-06-13T11:45:41.019Z",
                    "distance": 0,
                    "bearing": "0.0"
                },
                {
                    "id": 16,
                    "latitude": 33.253235541,
                    "longitude": 74.27327282603,
                    "user_id": 2,
                    "mark_type": 4,
                    "created_at": "2017-06-13T11:46:08.359Z",
                    "updated_at": "2017-06-13T11:46:08.359Z",
                    "distance": 0,
                    "bearing": "0.0"
                },
                {
                    "id": 2,
                    "latitude": 33.25323554,
                    "longitude": 74.273272826028,
                    "user_id": 2,
                    "mark_type": 3,
                    "created_at": "2017-06-12T06:05:49.998Z",
                    "updated_at": "2017-06-12T06:05:49.998Z",
                    "distance": 6.90936709256038e-8,
                    "bearing": "180.113990556052"
                },
                {
                    "id": 1,
                    "latitude": 33.25323554,
                    "longitude": 74.273272826028,
                    "user_id": 2,
                    "mark_type": 3,
                    "created_at": "2017-06-12T06:05:47.171Z",
                    "updated_at": "2017-06-12T06:05:47.171Z",
                    "distance": 6.90936709256038e-8,
                    "bearing": "180.113990556052"
                }
            ]
        }
      }
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