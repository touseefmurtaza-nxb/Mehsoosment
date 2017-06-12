module Api
  module V1
    class StatusesController < ApplicationController

      # ---------------------------------------- Create a new Status ---------------------------------------------------
      api :POST, '/v1/users/:uuid/statuses', 'Create new status'
      param "uuid", String, desc: 'User uuid, who wants to update status', required: true
      param "status_text", String, desc: 'Text that user wants to update', required: false
      param "image", File, desc: 'Image file to upload', required: false

      def create
        user = User.find_by_uuid params[:uuid]
        status = user.statuses.new (status_params)
        if status.save
          render :json => {
                 success:"true",
                 message:"Status Saved",
                 data:{ status: status },
                 status:200
          }
        else
          render :json => {
                   success:"false",
                   message:"",
                   data:{},
                   status:400
           }
        end
      end

      def update
      end

      private

      def status_params
        params.permit(:status_text, :image)
      end
    end
  end
end

