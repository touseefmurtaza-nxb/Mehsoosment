# if @mark_feeling.save
#   json.success "true"
#   json.message "Location Marked"
#   json.data do
#     json.latitude  @mark_feeling.latitude
#     json.longitude @mark_feeling.longitude
#     json.mark_type @mark_feeling.mark_type
#   end
# else
#   json.success "false"
#   json.message "Marked Location Didn't Save"
#   json.data do
#   end
# end