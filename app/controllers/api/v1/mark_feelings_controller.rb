module Api
  module V1
    class MarkFeelingsController < ApplicationController

      #---------------------------------------- Mark Feeling Location Point --------------------------------------------
      api :POST, '/v1/mark_feelings', 'Add Feeling'
      param :latitude, Float, desc: 'User current location latitude', required: true
      param :longitude, Float, desc: 'User current location longitude', required: true
      param :user_id, Integer, desc: 'User id, whose current location is marked', required: true
      param :mark_type, Integer, desc: 'Integer value to show proper feeling type = {1=>Happy,2=>Sad, 3=>Boring, 4=>Angry}', required: true
      def create
        @mark_feeling = MarkFeeling.new(latitude: params[:latitude], longitude: params[:longitude], user_id: params[:user_id], mark_type: params[:mark_type])
      end
    end
  end
end
