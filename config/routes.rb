# == Route Map
#
#                         Prefix Verb  URI Pattern                                        Controller#Action
#         apipie_apipie_checksum GET   /apidoc/apipie_checksum(.:format)                  apipie/apipies#apipie_checksum {:format=>/json/}
#                  apipie_apipie GET   /apidoc(/:version)(/:resource)(/:method)(.:format) apipie/apipies#index {:version=>/[^\/]+/, :resource=>/[^\/]+/, :method=>/[^\/]+/}
#                api_v1_statuses POST  /api/v1/users/:uuid/statuses(.:format)             api/v1/statuses#create
#                  api_v1_status PATCH /api/v1/users/:uuid/statuses/:id(.:format)         api/v1/statuses#update
#                                PUT   /api/v1/users/:uuid/statuses/:id(.:format)         api/v1/statuses#update
#                   api_v1_users POST  /api/v1/users(.:format)                            api/v1/users#create
#            api_v1_users_verify POST  /api/v1/users/verify(.:format)                     api/v1/users#verify
#             api_v1_update_user POST  /api/v1/users/update(.:format)                     api/v1/users#update_user
# api_v1_get_registered_contacts POST  /api/v1/users/registered_contacts(.:format)        api/v1/users#get_registered_contacts
#          api_v1_user_locations POST  /api/v1/user_locations(.:format)                   api/v1/user_locations#create
#           api_v1_mark_feelings POST  /api/v1/mark_feelings(.:format)                    api/v1/mark_feelings#create
#   api_v1_user_camera_locations POST  /api/v1/user_camera_locations(.:format)            api/v1/user_camera_locations#create
#            api_v1_mark_dangers POST  /api/v1/mark_dangers(.:format)                     api/v1/mark_dangers#create
#

Rails.application.routes.draw do
  apipie
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create, :destroy]
      resources :statuses, only: [:create, :destroy]
      resources :feature_codes, only: [:create]
      post '/apply_code' => "feature_codes#apply_code"
      post '/users/enabled_features' => "feature_codes#enabled_features"

      post 'users/verify' => "users#verify"
      post 'users/update' => "users#update_user", as: :update_user
      post 'users/registered_contacts' => "users#get_registered_contacts", as: :get_registered_contacts
      post '/users/refresh_token' => "users#refresh_token"
      post 'users/authenticate', to: 'authentication#authenticate'
      post 'users/register_as_guest', to: 'users#register_as_guest'

      post 'messages/send_message', to: 'messages#send_message'
      post 'messages/chats', to: 'messages#chats'
      post 'messages/room_messages', to: 'messages#room_messages'
      post 'messages/room', to: 'messages#room'
      delete 'messages/destroy_room', to: 'messages#destroy_room'

      post 'rooms/read_messages', to: 'rooms#read_messages'
      post 'rooms/unseen_messages', to: 'rooms#unseen_messages'
      post 'rooms/leave_room', to: 'rooms#leave_room'

      resources :user_locations, only: [:create]
      resources :mark_feelings, only: [:create]
      resources :user_camera_locations, only: [:create]
      resources :mark_dangers, only: [:create]
    end
  end

end
