# if @update
#   json.success "true"
#   json.message "User Setting Updated"
#   json.data do
#     json.user_id @user.id
#     json.phone_number @user.phone_number
#     json.first_name @user.f_name
#     json.last_name @user.l_name
#     json.email @user.email
#     # json.distance @user.distance
#     json.notification @user.notification
#   end
# else
#   json.success "false"
#   json.message ""
#   json.data do
#   end
# end