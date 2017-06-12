if @mark_danger.save
  json.success "true"
  json.message "Location Marked"
  json.data do
    json.latitude @mark_danger.latitude
    json.longitude @mark_danger.longitude
    json.mark_type @mark_danger.mark_type
  end
else
  json.success "false"
  json.message "Marked Location Didn't Save"
  json.data do
  end
end