Rails.application.routes.draw do
  get 'games/current_state_obs', to: 'games#current_state_obs'
  resources :games
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  post "new_game" => "games#new_game"
  post "update_status" => "games#update_status"
  post "update_votes" => "games#update_votes"
  post "update_log" => "games#update_log"
  post "stop_game" => "games#stop"
  resources :users

  root "games#index"
end
