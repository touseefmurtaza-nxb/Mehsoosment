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
                      "id": 127,
                      "latitude": 0,
                      "longitude": 0,
                      "user_id": 15,
                      "mark_type": 1,
                      "distance": 5572.018830229658,
                      "created_at": "21 days ago",
                      "updated_at": "2017-06-15T12:07:30.618Z",
                      "user_status": {
                          "status_id": 47,
                          "status_text": "",
                          "image_url": "mehsoosment.vteamslabs.com/system/statuses/images/000/000/047/original/20170705_165548.jpg?1499343810"
                      }
                  },
                  {
                      "id": 126,
                      "latitude": 0,
                      "longitude": 0,
                      "user_id": 15,
                      "mark_type": 4,
                      "distance": 5572.018830229658,
                      "created_at": "21 days ago",
                      "updated_at": "2017-06-20T06:08:09.585Z",
                      "user_status": {
                          "status_id": 47,
                          "status_text": "",
                          "image_url": "mehsoosment.vteamslabs.com/system/statuses/images/000/000/047/original/20170705_165548.jpg?1499343810"
                      }
                  }
              ],
              "stats": {
                  "Happy": 3,
                  "Angry": 3,
                  "Boring": 1,
                  "Sad": 1
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
              status_hsh['image_url'] = "mehsoosment.vteamslabs.com"+status.image.url
            else
              status_hsh['status_id'] = ""
              status_hsh['status_text'] = ""
              status_hsh['image_url'] = ""
            end
            mark_feeling_hash = {}
            point = Geokit::LatLng.new(params[:latitude], params[:longitude])
            distance = markup.distance_to point
            if markup.created_at < Date.today
              created_at = time_diff(markup.created_at,DateTime.now)
              # created_at = (DateTime.now.to_i - markup.created_at.to_i)/(60*60*24)
              # created_at = minutes_in_words(created_at.day) + " ago"
              # created_at = helper.distance_of_time_in_words(Time.at(0), Time.at(created_at.day)) + " ago"
              # created_at = (created_at == 1) ? ("#{created_at} day ago") : ("#{created_at} days ago")
            else
              created_at = markup.created_at.strftime("%I:%M %p")
            end

            mark_feeling_hash['id']             = markup.id
            mark_feeling_hash['latitude']       = markup.latitude
            mark_feeling_hash['longitude']      = markup.longitude
            mark_feeling_hash['user_id']        = markup.user_id
            mark_feeling_hash['mark_type']      = markup.mark_type
            mark_feeling_hash['distance']       = distance
            mark_feeling_hash['created_at']     = created_at
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
