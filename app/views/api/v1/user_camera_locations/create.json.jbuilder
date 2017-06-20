if @markups
  json.success "true"
  json.message "Location Saved"
  json.data do
    if @alert.nil?
      @alert = ""
    end
    json.alert @alert
    # json.markers @markups

    json.markers @markups do |markup|
      json.(markup, :id, :latitude, :longitude, :user_id, :mark_type, :created_at, :updated_at, :distance, :bearing)
      json.user_status do
        status = markup.user.try(:statuses).try(:last)
        if status
          json.status_id status.id
          json.status_text status.status_text
          json.image_url status.image.url
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