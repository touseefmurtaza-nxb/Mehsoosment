# if @markups
#   json.success "true"
#   json.message "Location Saved"
#   json.data do
#     if @alert.nil?
#       @alert = ""
#     end
#     json.alert @alert
#     json.markers @markups
#     json.stats @stats
#   end
# else
#   json.success "false"
#   json.message "Location Didn't Save"
#   json.data do
#   end
# end