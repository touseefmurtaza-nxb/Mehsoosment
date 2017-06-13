module Api
  	module V1
		class AuthenticationController < ApplicationController
			skip_before_action :authenticate_request

			# ---------------------------------------- Mark Danger Location Point --------------------------------------------
      api :POST, '/v1/users/authenticate', 'Authenticate User'
      param :email, String, desc: 'User Email', required: true
      param :password, String, desc: 'User password', required: true

			def authenticate
				command = AuthenticateUser.call(params[:email], params[:password])

				if command.success?
					render json: { auth_token: command.result }
				else
					render json: { error: command.errors }, status: :unauthorized
				end
			end
		end
	end
end