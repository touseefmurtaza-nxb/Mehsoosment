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
            "status": {
                "id": 11,
                "status_text": "Hello friends",
                "user_id": 2,
                "expires_at": "2017-06-14T12:54:10.574Z",
                "created_at": "2017-06-13T12:54:10.574Z",
                "updated_at": "2017-06-13T12:54:10.574Z",
                "image_file_name": "school-house-images-7ianLEjiA.jpeg",
                "image_content_type": "image/jpeg",
                "image_file_size": 28083,
                "image_updated_at": "2017-06-13T12:54:10.465Z"
            },
            "image_url": "/system/statuses/images/000/000/011/original/school-house-images-7ianLEjiA.jpeg?1497358450"
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
                 data:{ status: status, image_url: status.image.url },
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

