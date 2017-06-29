module Api
  module V1
    module UserLocationsHelper

      def send_notification(markups)
        all_markers = markups
        user_markers = MarkDanger.where(:user_id => @location.user.id)
        other_markers = all_markers - user_markers
        unless other_markers.empty?
          marker = other_markers.first
          distance = marker.distance.round(3)
          mark_type = MarkDanger::MARK_TYPE[marker.mark_type]
          device_token = @location.user.try(:device).try(:device_token)
          unless device_token.nil?
            registration_ids = []
            registration_ids << device_token
            if (distance < 0.009)
              @alert = "You are on #{mark_type} place."
            else
              @alert = "You are #{distance} miles away from #{mark_type}."
            end
            if @location.user.allow_notifications?
              if @location.user.device.device_type.eql?("android")
                fcm = FCM.new(ENV['FCM_API_KEY'])
                options = {:data => {:body => "#{@alert}", :title => "#{mark_type} alert"}}
                response = fcm.send(registration_ids, options)
              elsif @location.user.device.device_type.eql?("iOS")
                # APNS.send_notification(device_token, :@alert => "#{@alert}", :badge => 1, :sound => 'default')
                APNS.send_notification(device_token, :alert => "#{@alert}", :badge => 1, :sound => 'default', :other => {:type => 1})
              end
            end
          end
        end
      end

      def find_markers
        markers_array = []
        encoded_line = Polylines::Encoder.encode_points([[params[:ne]["0"],params[:ne]["1"]], [params[:nw]["0"],params[:nw]["1"]], [params[:se]["0"],params[:se]["1"]], [params[:sw]["0"],params[:sw]["1"]]])
        decoded_poly_lines = Polylines::Decoder.decode_polyline(encoded_line)
        polygon_points_arr = []
        decoded_poly_lines.each do |path_point|
          polygon_points_arr << Geokit::LatLng.new(path_point[0], path_point[1])
        end
        polygon = Geokit::Polygon.new(polygon_points_arr)

        MarkFeeling.each do |marked_feeling|
          address = [marked_feeling.latitude, marked_feeling.longitude]
          latlong_points = Geocoder.coordinates(address)
          point = Geokit::LatLng.new(latlong_points[0], latlong_points[1])
          if polygon.contains?(point)
            markers_array << marked_feeling
          end
        end
      end

    end
  end
end