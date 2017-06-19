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
            "markers": [],
            "stats": {}
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
          mark_feeling_hash = {}
          markers_array = []
          @markups.each do |markup|
            point = Geokit::LatLng.new(params[:latitude], params[:longitude])
            distance = markup.distance_to point
            mark_feeling_hash['id'] = markup.id
            mark_feeling_hash['latitude'] = markup.latitude
            mark_feeling_hash['longitude'] = markup.longitude
            mark_feeling_hash['user_id'] = markup.user_id
            mark_feeling_hash['mark_type'] = markup.mark_type
            mark_feeling_hash['distance'] = distance
            mark_feeling_hash['created_at'] = markup.created_at
            mark_feeling_hash['updated_at'] = markup.updated_at
            markers_array << mark_feeling_hash
          end
          # @markups = MarkFeeling.near([@location.latitude,@location.longitude],6)
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
