class ApplicationController < ActionController::API
  helper_method :time_diff
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

  def time_diff(start_date,end_date)
    start_time = start_date.to_time if start_date.respond_to?(:to_time)
    end_time = end_date.to_time if end_date.respond_to?(:to_time)
    distance_in_seconds = ((end_time - start_time).abs).round
    components = get_time_diff_components(%w(year month week day), distance_in_seconds)
    time_diff_components = {:year => components[0], :month => components[1], :week => components[2], :day => components[3]}
    if time_diff_components[:year] > 0 && time_diff_components[:year] > 1
      return "#{time_diff_components[:year]} years ago"
    elsif time_diff_components[:year] > 0
      return "#{time_diff_components[:year]} year ago"
    elsif time_diff_components[:month] > 0 && time_diff_components[:month] > 1
      return "#{time_diff_components[:month]} months ago"
    elsif time_diff_components[:month] > 0
      return "#{time_diff_components[:month]} month ago"
    elsif time_diff_components[:week] > 0 && time_diff_components[:week] > 1
      return "#{time_diff_components[:week]} weeks ago"
    elsif time_diff_components[:week] > 0
      return "#{time_diff_components[:week]} week ago"
    elsif time_diff_components[:day] > 0 && time_diff_components[:day] > 1
      return "#{time_diff_components[:day]} days ago"
    elsif time_diff_components[:day] > 0
      return "#{time_diff_components[:day]} day ago"
    end
  end
  def get_time_diff_components(intervals, distance_in_seconds)
    components = []
    intervals.each do |interval|
      component = (distance_in_seconds / 1.send(interval)).floor
      distance_in_seconds -= component.send(interval)
      components << component
    end
    components
  end
end