class ApplicationController < ActionController::API
  before_action :grant_params
  before_action :authenticate_request
  attr_reader :current_user

  def grant_params
    params.permit!
  end

  private

  def authenticate_request
  	@current_user = AuthorizeApiRequest.call(request.headers).result
    if @current_user == 'Expired'
      render json: { error: 'Token Expired' }, status: 401
    elsif @current_user == 'Invalid'
      render json: { error: 'Invalid Token' }, status: 401
    elsif @current_user.nil?
      render json: { error: 'Not Authorized' }, status: 401
    end
  end
end