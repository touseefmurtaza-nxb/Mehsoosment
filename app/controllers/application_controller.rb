class ApplicationController < ActionController::API
  before_filter :grant_params

  def grant_params
    params.permit!
  end
end
