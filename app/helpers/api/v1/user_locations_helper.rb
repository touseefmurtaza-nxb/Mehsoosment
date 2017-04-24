module Api
  module V1
    module UserLocationsHelper

      def send_notification(markups)
        all_markers = markups
        user_markers = MarkFeeling.where(:user_id => @location.user.id)
        other_markers = all_markers - user_markers
        unless other_markers.empty?
          marker = other_markers.first
          distance = marker.distance.round(3)
          mark_type = MarkFeeling::MARK_TYPE[marker.mark_type]
          device_token = @location.user.device.device_token
          registration_ids = []
          registration_ids << device_token
          if (distance < 0.009)
            @alert = "There is a #{mark_type} person."
          else
            @alert = "There is a #{mark_type} person #{distance} miles away from you."
          end
          if @location.user.allow_notifications?
            if @location.user.device.device_type.eql?("android")
              fcm = FCM.new(ENV['FCM_API_KEY'])
              options = {:data => {:body => "#{@alert}", :title => "#{mark_type} alert"}}
              response = fcm.send(registration_ids, options)
            elsif @location.user.device.device_type.eql?("iOS")
              APNS.send_notification(device_token, :@alert => "#{@alert}", :badge => 1, :sound => 'default')
            end
          end
        end
      end
    end
  end
end