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
                    "id": 148,
                    "latitude": 31.4713498,
                    "longitude": 74.2728264,
                    "user_id": 15,
                    "mark_type": 3,
                    "distance": 0.008723732312775739,
                    "created_at": "2017-07-05T16:26:06.779Z",
                    "updated_at": "2017-07-05T16:26:06.779Z",
                    "user_status": {
                        "status_id": 47,
                        "status_text": "",
                        "image_url": "/system/statuses/images/000/000/047/original/20170705_165548.jpg?1499343810"
                    }
                },
                {
                    "id": 147,
                    "latitude": 31.4712413633535,
                    "longitude": 74.2729054112679,
                    "user_id": 12,
                    "mark_type": 4,
                    "distance": 0.003137209423510219,
                    "created_at": "2017-07-04T08:12:44.385Z",
                    "updated_at": "2017-07-04T08:12:44.385Z",
                    "user_status": {
                        "status_id": 46,
                        "status_text": "Hello how are you??",
                        "image_url": "/system/statuses/images/000/000/046/original/image.jpg?1499323881"
                    }
                },
                {
                    "id": 146,
                    "latitude": 31.4646732,
                    "longitude": 74.2710947,
                    "user_id": 20,
                    "mark_type": 1,
                    "distance": 0.4693574517316555,
                    "created_at": "2017-07-03T04:50:56.945Z",
                    "updated_at": "2017-07-03T04:50:56.945Z",
                    "user_status": {
                        "status_id": 44,
                        "status_text": "bbj",
                        "image_url": "/system/statuses/images/000/000/044/original/tmp1498835772064.png?1498835476"
                    }
                },
                {
                    "id": 145,
                    "latitude": 31.4713093,
                    "longitude": 74.2729398,
                    "user_id": 0,
                    "mark_type": 1,
                    "distance": 0.002527712876648135,
                    "created_at": "2017-06-30T15:56:06.061Z",
                    "updated_at": "2017-06-30T15:56:06.061Z",
                    "user_status": {
                        "status_id": "",
                        "status_text": "",
                        "image_url": ""
                    }
                }
            ],
            "stats": {
                "Sad": 32,
                "Happy": 47,
                "Boring": 17,
                "Angry": 29,
                "": 1
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
              status_hsh['status_id'] = status.id
              status_hsh['status_text'] = status.status_text
              status_hsh['image_url'] = status.image.url
            else
              status_hsh['status_id'] = ""
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
                           markers: markers_array.sort! { |x,y| y["id"] <=> x["id"] },
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
