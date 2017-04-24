Rails.application.routes.draw do
  apipie
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create]
      post 'users/verify' => "users#verify"
      post 'users/update' => "users#update_user", as: :update_user
      resources :user_locations, only: [:create]
      resources :mark_feelings, only: [:create]
    end
  end
end
