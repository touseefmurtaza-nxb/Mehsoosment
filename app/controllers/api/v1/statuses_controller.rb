module Api
  module V1
    class StatusesController < ApplicationController

      # ---------------------------------------- Create a new Status ---------------------------------------------------
      api :POST, '/v1/statuses', 'Create new status'
      param "uuid", String, desc: 'User uuid, who wants to update status', required: true
      param "status_text", String, desc: 'Text that user wants to update', required: false
      param "image", File, desc: 'Image file to upload', required: false
      example <<-EOS
      {
        "success": "true",
        "message": "Status Saved",
        "data": {
            "status_id": 22,
            "status_text": "Hello, How Are You Doing?",
            "user_id": 2,
            "uuid": "64f0e0c5-20f4-4071-a31b-e0b8ca69a938",
            "expires_at": "2017-06-22T11:27:33.839Z",
            "created_at": "2017-06-21T11:27:33.839Z",
            "image_url": "/system/statuses/images/000/000/022/original/18238194_1566992733334257_8603697286439955519_o.jpg?1498044453"
        },
        "status": 200
      }
      EOS
      description <<-EOS
        == Authentication required
         Authentication token has to be passed as part of the request. It can be passed as parameter in HTTP header(Authorization).
      EOS
      def create
        user = User.find_by_uuid params[:uuid]
        status = user.statuses.new (status_params)
        if status.save
          render :json => {
                 success:"true",
                 message:"Status Saved",
                 data:{
                     status_id: status.id,
                     status_text: status.status_text,
                     user_id: status.user.id,
                     uuid: status.user.uuid,
                     expires_at: status.expires_at,
                     created_at: status.created_at,
                     image_url: status.image.url
                 },
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

      # ---------------------------------------- Delete Status ---------------------------------------------------
      api :DELETE, '/v1/statuses/:id', 'Destroy Status'
      param "id", Integer, desc: 'Status ID', required: true
      example <<-EOS
      {
        "success": "true",
        "message": "Status Destroyed",
        "data": {},
        "status": 200
      }
      EOS
      description <<-EOS
        == Authentication required
         Authentication token has to be passed as part of the request. It can be passed as parameter in HTTP header(Authorization).
      EOS
      def destroy
        status = Status.find params[:id]
        if status.destroy
          render :json => {
                     success:"true",
                     message:"Status Destroyed",
                     data:{},
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

      private

      def status_params
        params.permit(:status_text, :image)
      end
    end
  end
end

