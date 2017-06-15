module Api
  module V1
    class FeatureCodesController < ApplicationController
      def create
        feature = Feature.find_by_name(params[:feature_name])
        if feature
          feature_code = FeatureCode.new(feature_id: feature.id)
          feature_code.generate_code
          if feature_code.save!
            render :json => {
                       success:"true",
                       message:"Code Created",
                       data:
                           {
                              feature:feature.name,
                              code:feature_code.code
                           },
                       status:200
                   }
          end
        end
      end

      #---------------------------------------- Apply Feature Code to Enable Feature --------------------------------------------
      api :POST, '/v1/apply_code', 'Apply Code'
      param :uuid, String, desc: 'User UUID', required: true
      param :feature_name, String, desc: 'Feature Name i.e. camera', required: true
      param :code, String, desc: 'Feature Code', required: true
      example <<-EOS
      {
          "success": "true",
          "message": "Code Applied",
          "data": {},
          "status": 200
      }
      EOS
      description <<-EOS
        == Authentication required
         Authentication token has to be passed as part of the request. It can be passed as parameter in HTTP header(Authorization).
      EOS
      def apply_code
        user = User.find_by uuid: params[:uuid]
        feature = Feature.find_by_name params[:feature_name]
        feature_code = FeatureCode.where(code: params[:code]).first
        if (feature_code) && (feature_code.feature.name == params[:feature_name])
          feature.user_id = user.id
          feature.save!
          render :json => {
                     success:"true",
                     message:"Code Applied",
                     data:{},
                     status:200
                 }
        else
          render :json => {
                     success:"false",
                     message:"Invalid Code",
                     data:{},
                     status:400
                 }
        end
      end

      #---------------------------------------- Get User Enabled Features --------------------------------------------
      api :POST, '/v1/users/enabled_features', 'User Enabled Features'
      param :uuid, String, desc: 'User UUID', required: true
      example <<-EOS
      {
          "success": "true",
          "message": "",
          "data": {
              "features": [
                  {
                      "id": 1,
                      "name": "camera",
                      "user_id": 2,
                      "created_at": "2017-06-14T12:14:30.920Z",
                      "updated_at": "2017-06-15T07:27:14.375Z"
                  }
              ]
          },
          "status": 200
      }
      EOS
      description <<-EOS
        == Authentication required
         Authentication token has to be passed as part of the request. It can be passed as parameter in HTTP header(Authorization).
      EOS
      def enabled_features
        user = User.find_by uuid: params[:uuid]
        if user
          render :json => {
                     success:"true",
                     message:"",
                     data:{features: user.features},
                     status:200
                 }
        end
      end

    end
  end
end