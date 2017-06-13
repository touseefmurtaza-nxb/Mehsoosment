module Api
  module V1
    class MarkDangersController < ApplicationController
      # ---------------------------------------- Mark Danger Location Point --------------------------------------------
      api :POST, '/v1/mark_dangers', 'Create a challan point'
      param :latitude, Float, desc: 'User current location latitude', required: true
      param :longitude, Float, desc: 'User current location longitude', required: true
      param :user_id, Integer, desc: 'User id, whose current location is marked', required: true
      param :mark_type, Integer, desc: 'Integer value to show proper challan type {1=>Camera,2=>Challan, 3=>Naaka, 4=>Crime}', required: true
      example <<-EOS
      {
        "success": "true",
        "message": "Location Marked",
        "data": {
            "latitude": 33.253235541,
            "longitude": 74.27327282603,
            "mark_type": 4
        }
      }
      EOS
      def create
        @mark_danger = MarkDanger.new(latitude: params[:latitude], longitude: params[:longitude], user_id: params[:user_id], mark_type: params[:mark_type])
      end
    end
  end
end