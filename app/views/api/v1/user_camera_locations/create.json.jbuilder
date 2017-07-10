if @markups
  json.success "true"
  json.message "Location Saved"
  json.data do
    if @alert.nil?
      @alert = ""
    end
    json.alert @alert
    # json.markers @markups.reorder('id DESC').as_json(methods: [:user_status])

    json.markers @markups.reorder('id DESC') do |markup|
      if markup.created_at < Date.today
        created_at = (DateTime.now.to_i - markup.created_at.to_i)/(60*60*24)
        created_at = distance_of_time_in_words(Time.at(0), Time.at(created_at.day))
        # created_at = (created_at == 1) ? ("#{created_at} day ago") : ("#{created_at} days ago")
      else
        created_at = markup.created_at
      end
      # json.(markup, :id, :latitude, :longitude, :user_id, :mark_type, :created_at, :updated_at, :distance, :bearing)
      json.id markup.id
      json.latitude markup.latitude
      json.longitude markup.longitude
      json.user_id markup.user_id
      json.mark_type markup.mark_type
      json.created_at created_at
      json.updated_at markup.updated_at
      json.distance markup.distance
      json.bearing markup.bearing
      
      json.user_status do
        status = markup.user.try(:statuses).try(:last)
        if status
          json.status_id status.id
          json.status_text status.status_text
          json.image_url "mehsoosment.vteamslabs.com"+status.image.url
        else
          json.status_id ""
          json.status_text ""
          json.image_url ""
        end
      end
    end

  end
else
  json.success "false"
  json.message "Location Didn't Save"
  json.data do
  end
end