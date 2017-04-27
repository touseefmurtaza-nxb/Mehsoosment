# if @user
#   if ((@user.verified?) and (!@user.expired?))
#     json.success "true"
#     json.message ""
#     json.data do
#       json.user_id @user.id
#       json.phone_number @user.phone_number
#       json.first_name @user.f_name
#       json.last_name @user.l_name
#       json.email @user.email
#       # json.distance @user.distance
#       json.notification @user.notification
#     end
#   elsif @user.expired?
#     json.success "false"
#     json.message "PIN Expired"
#     json.data do
#     end
#   else
#     json.success "false"
#     json.message "Invalid PIN"
#     json.data do
#     end
#   end
# else
#   json.success "false"
#   json.message ""
#   json.data do
#   end
# end