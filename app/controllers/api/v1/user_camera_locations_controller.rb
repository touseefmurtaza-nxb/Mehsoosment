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
            "alert": "",
            "markers": [
                {
                    "id": 23,
                    "latitude": 30.253235541,
                    "longitude": 72.273272016,
                    "user_id": 2,
                    "mark_type": 4,
                    "created_at": "2017-06-19T10:38:31.524Z",
                    "updated_at": "2017-06-19T10:38:31.524Z",
                    "distance": 0,
                    "bearing": "0.0",
                    "user_status": {
                        "status_id": 16,
                        "status_text": "testing",
                        "image_url": ""
                    }
                },
                {
                    "id": 24,
                    "latitude": 30.253235541,
                    "longitude": 72.273272016,
                    "user_id": 2,
                    "mark_type": 1,
                    "created_at": "2017-06-19T10:38:34.774Z",
                    "updated_at": "2017-06-19T10:38:34.774Z",
                    "distance": 0,
                    "bearing": "0.0",
                    "user_status": {
                        "status_id": 16,
                        "status_text": "testing",
                        "image_url": ""
                    }
                },
                {
                    "id": 25,
                    "latitude": 30.253235541,
                    "longitude": 72.273272016,
                    "user_id": 2,
                    "mark_type": 3,
                    "created_at": "2017-06-19T10:38:38.011Z",
                    "updated_at": "2017-06-19T10:38:38.011Z",
                    "distance": 0,
                    "bearing": "0.0",
                    "user_status": {
                        "status_id": 16,
                        "status_text": "testing",
                        "image_url": ""
                    }
                },
                {
                    "id": 26,
                    "latitude": 30.253235541,
                    "longitude": 72.273272016,
                    "user_id": 3,
                    "mark_type": 3,
                    "created_at": "2017-06-19T10:39:20.703Z",
                    "updated_at": "2017-06-19T10:39:20.703Z",
                    "distance": 0,
                    "bearing": "0.0",
                    "user_status": {
                        "status_id": "",
                        "status_text": "",
                        "image_url": ""
                    }
                },
                {
                    "id": 22,
                    "latitude": 30.253235541,
                    "longitude": 72.273272026,
                    "user_id": 2,
                    "mark_type": 4,
                    "created_at": "2017-06-19T10:38:26.897Z",
                    "updated_at": "2017-06-19T10:38:26.897Z",
                    "distance": 5.96832633730437e-7,
                    "bearing": "89.99999997945",
                    "user_status": {
                        "status_id": 16,
                        "status_text": "testing",
                        "image_url": ""
                    }
                },
                {
                    "id": 21,
                    "latitude": 30.253235541,
                    "longitude": 72.273272826,
                    "user_id": 2,
                    "mark_type": 3,
                    "created_at": "2017-06-19T10:38:19.533Z",
                    "updated_at": "2017-06-19T10:38:19.533Z",
                    "distance": 0.0000483434730174405,
                    "bearing": "89.99999997945",
                    "user_status": {
                        "status_id": 16,
                        "status_text": "testing",
                        "image_url": ""
                    }
                },
                {
                    "id": 20,
                    "latitude": 30.253235541,
                    "longitude": 72.273272826,
                    "user_id": 2,
                    "mark_type": 2,
                    "created_at": "2017-06-19T10:33:33.864Z",
                    "updated_at": "2017-06-19T10:33:33.864Z",
                    "distance": 0.0000483434730174405,
                    "bearing": "89.99999997945",
                    "user_status": {
                        "status_id": 16,
                        "status_text": "testing",
                        "image_url": ""
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