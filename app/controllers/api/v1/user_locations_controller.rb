module Api
  module V1
    class UserLocationsController < ApplicationController
      include UserLocationsHelper

      # ---------------------------------------- Save User Current Location and return nearby Feeling markups -----------
      api :POST, '/v1/user_locations', 'Update user location'
      param :latitude, Float, desc: 'User current location latitude', required: true
      param :longitude, Float, desc: 'User current location longitude', required: true
      param :user_id, Integer, desc: 'User id, whose current location is marked', required: true
      param :south_west_point, String, desc: 'South West Point comma separated e.g. (31.469111,74.27178)', required: true
      param :north_east_point, String, desc: 'North East Point comma separated e.g. (31.469111,74.27178)', required: true
      example <<-EOS
      {
        "success": "true",
        "message": "Location Saved",
        "data": {
            "alert": null,
            "markers": [
                {
                    "id": 9,
                    "latitude": 32.25323554,
                    "longitude": 74.273272826028,
                    "user_id": 2,
                    "mark_type": 2,
                    "distance": 181.99381623993563,
                    "created_at": "2017-04-27T12:10:45.400Z",
                    "updated_at": "2017-04-27T12:10:45.400Z",
                    "user_status": {
                        "id": 16,
                        "status_text": "testing",
                        "image_url": ""
                    }
                },
                {
                    "id": 10,
                    "latitude": 32.25323554,
                    "longitude": 74.273272826028,
                    "user_id": 2,
                    "mark_type": 2,
                    "distance": 181.99381623993563,
                    "created_at": "2017-04-27T12:10:46.438Z",
                    "updated_at": "2017-04-27T12:10:46.438Z",
                    "user_status": {
                        "id": 16,
                        "status_text": "testing",
                        "image_url": ""
                    }
                },
                {
                    "id": 11,
                    "latitude": 33.25323554,
                    "longitude": 74.273272826028,
                    "user_id": 2,
                    "mark_type": 3,
                    "distance": 238.52056167478267,
                    "created_at": "2017-04-27T12:10:56.273Z",
                    "updated_at": "2017-04-27T12:10:56.273Z",
                    "user_status": {
                        "id": 16,
                        "status_text": "testing",
                        "image_url": ""
                    }
                },
                {
                    "id": 20,
                    "latitude": 33.25323554,
                    "longitude": 74.273272826028,
                    "user_id": 2,
                    "mark_type": 4,
                    "distance": 238.52056167478267,
                    "created_at": "2017-04-28T11:50:49.097Z",
                    "updated_at": "2017-04-28T11:50:49.097Z",
                    "user_status": {
                        "id": 16,
                        "status_text": "testing",
                        "image_url": ""
                    }
                },
                {
                    "id": 21,
                    "latitude": 33.25323554,
                    "longitude": 74.273272826028,
                    "user_id": 2,
                    "mark_type": 4,
                    "distance": 238.52056167478267,
                    "created_at": "2017-04-28T11:50:52.360Z",
                    "updated_at": "2017-04-28T11:50:52.360Z",
                    "user_status": {
                        "id": 16,
                        "status_text": "testing",
                        "image_url": ""
                    }
                },
                {
                    "id": 22,
                    "latitude": 33.25323554,
                    "longitude": 74.273272826028,
                    "user_id": 2,
                    "mark_type": 4,
                    "distance": 238.52056167478267,
                    "created_at": "2017-04-28T11:50:52.927Z",
                    "updated_at": "2017-04-28T11:50:52.927Z",
                    "user_status": {
                        "id": 16,
                        "status_text": "testing",
                        "image_url": ""
                    }
                },
                {
                    "id": 23,
                    "latitude": 33.25323554,
                    "longitude": 74.273272826028,
                    "user_id": 2,
                    "mark_type": 2,
                    "distance": 238.52056167478267,
                    "created_at": "2017-04-28T11:50:56.528Z",
                    "updated_at": "2017-04-28T11:50:56.528Z",
                    "user_status": {
                        "id": 16,
                        "status_text": "testing",
                        "image_url": ""
                    }
                },
                {
                    "id": 24,
                    "latitude": 33.25323554,
                    "longitude": 74.273272826028,
                    "user_id": 2,
                    "mark_type": 2,
                    "distance": 238.52056167478267,
                    "created_at": "2017-04-28T11:50:56.989Z",
                    "updated_at": "2017-04-28T11:50:56.989Z",
                    "user_status": {
                        "id": 16,
                        "status_text": "testing",
                        "image_url": ""
                    }
                },
                {
                    "id": 25,
                    "latitude": 33.25323554,
                    "longitude": 74.273272826028,
                    "user_id": 2,
                    "mark_type": 3,
                    "distance": 238.52056167478267,
                    "created_at": "2017-04-28T11:51:02.419Z",
                    "updated_at": "2017-04-28T11:51:02.419Z",
                    "user_status": {
                        "id": 16,
                        "status_text": "testing",
                        "image_url": ""
                    }
                },
                {
                    "id": 26,
                    "latitude": 33.25323554,
                    "longitude": 74.273272826028,
                    "user_id": 2,
                    "mark_type": 3,
                    "distance": 238.52056167478267,
                    "created_at": "2017-04-28T11:51:02.943Z",
                    "updated_at": "2017-04-28T11:51:02.943Z",
                    "user_status": {
                        "id": 16,
                        "status_text": "testing",
                        "image_url": ""
                    }
                },
                {
                    "id": 27,
                    "latitude": 33.25323554,
                    "longitude": 74.273272826028,
                    "user_id": 2,
                    "mark_type": 3,
                    "distance": 238.52056167478267,
                    "created_at": "2017-04-28T11:51:03.447Z",
                    "updated_at": "2017-04-28T11:51:03.447Z",
                    "user_status": {
                        "id": 16,
                        "status_text": "testing",
                        "image_url": ""
                    }
                }
            ],
            "stats": {
                "Sad": 4,
                "Boring": 4,
                "Angry": 3
            }
        },
        "status": 200
      }
      EOS
      description <<-EOS
        == Authentication required
         Authentication token has to be passed as part of the request. It can be passed as parameter in HTTP header(Authorization).
      EOS
      def create
        @location = UserLocation.new(latitude: params[:latitude], longitude: params[:longitude], user_id: params[:user_id])
        if @location.save
          p1 = Geokit::LatLng.new(params[:south_west_point].split(",")[0], params[:south_west_point].split(",")[1])
          p2 = Geokit::LatLng.new(params[:north_east_point].split(",")[0], params[:north_east_point].split(",")[1])
          @markups = MarkFeeling.in_bounds([p1, p2])
          markers_array = []
          @markups.each do |markup|
            status_hsh = {}
            status = markup.user.try(:statuses).try(:last)
            if status
              status_hsh['id'] = status.id
              status_hsh['status_text'] = status.status_text
              status_hsh['image_url'] = status.image.url
            else
              status_hsh['id'] = ""
              status_hsh['status_text'] = ""
              status_hsh['image_url'] = ""
            end
            mark_feeling_hash = {}
            point = Geokit::LatLng.new(params[:latitude], params[:longitude])
            distance = markup.distance_to point
            mark_feeling_hash['id']             = markup.id
            mark_feeling_hash['latitude']       = markup.latitude
            mark_feeling_hash['longitude']      = markup.longitude
            mark_feeling_hash['user_id']        = markup.user_id
            mark_feeling_hash['mark_type']      = markup.mark_type
            mark_feeling_hash['distance']       = distance
            mark_feeling_hash['created_at']     = markup.created_at
            mark_feeling_hash['updated_at']     = markup.updated_at
            mark_feeling_hash['user_status']    = status_hsh
            markers_array << mark_feeling_hash
          end
          # @markups = MarkFeeling.near([@loca  tion.latitude,@location.longitude],6)
          @stats_hash = {}
          @markups.group_by(&:mark_type).map {|k,v| @stats_hash[MarkFeeling::MARK_TYPE[k]] = v.length}
          # send_notification(@markups)
          if @markups
            render :json => {
                       success: "true",
                       message: "Location Saved",
                       data:{
                           alert: @alert,
                           markers: markers_array,
                           stats: @stats_hash
                       },
                       status:200
                   }
          else
            render :json => {
                       success:"false",
                       message:"Location Didn't Save",
                       data:{},
                       status:400
                   }
          end
        end
      end
    end
  end
end
