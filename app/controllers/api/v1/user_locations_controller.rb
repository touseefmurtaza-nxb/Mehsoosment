module Api
  module V1
    class UserLocationsController < ApplicationController
      include UserLocationsHelper

      # ---------------------------------------- Save User Current Location and return nearby Feeling markups -----------
      api :POST, '/v1/user_locations', 'Update user location'
      param :latitude, Float, desc: 'User current location latitude', required: true
      param :longitude, Float, desc: 'User current location longitude', required: true
      param :user_id, Integer, desc: 'User id, whose current location is marked', required: true
      param :ne, Integer, desc: 'North East', required: true
      param :se, Integer, desc: 'South East', required: true
      param :nw, Integer, desc: 'North West', required: true
      param :sw, Integer, desc: 'South West', required: true
      def create
        @location = UserLocation.new(latitude: params[:latitude], longitude: params[:longitude], user_id: params[:user_id])
        if @location.save
          # @markups = MarkFeeling.near([@location.latitude,@location.longitude],6)
          @markups = MarkFeeling.where(:latitude => params[:ne]..params[:se], :longitude => params[:nw]..params[:sw])
          @stats = @markups.group_by(&:mark_type).map {|k,v| [MarkFeeling::MARK_TYPE[k], v.length]}
          # send_notification(@markups)
          if @markups
            render :json => {
                       success: "true",
                       message: "Location Saved",
                       data:{
                           alert: @alert,
                           markers: @markups,
                           stats: @stats
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
