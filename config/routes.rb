# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', defaults: { format: 'json' }

      resources :tables
      resources :users

      post 'new_game' => 'games#new_game'
      post 'update_status' => 'games#update_status'
      post 'update_votes' => 'games#update_votes'
      post 'update_log' => 'games#update_log'
      post 'stop_game' => 'games#stop'
    end
  end

  get 'users/edit', to: 'users#edit'
  get 'broadcast/:token', to: 'games#current_state_obs', as: 'broadcast'

  resources :clubs do
    member do
      post 'join'
      get 'accept/:user_id', to: 'clubs#accept', as: 'accept'
      get 'reject/:user_id', to: 'clubs#reject', as: 'reject'
      delete 'demote_member/:user_id', to: 'clubs#demote_member', as: 'demote_member'
      post 'promote_member/:user_id', to: 'clubs#promote_member', as: 'promote_member'
      delete 'leave_admin', to: 'clubs#leave_admin', as: 'leave_admin'
      delete 'delete_member/:user_id', to: 'clubs#delete_member', as: 'delete_member'
      delete 'leave'
      post 'admin'
      get 'games'

      get 'general'
      get 'members'
      get 'tables'
      get 'manage/invitees', to: 'clubs#manage_invitees'
    end
  end

  resources :games do
    collection do
      get 'current_state_obs'
      get 'my'
    end
  end

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  get 'up' => 'rails/health#show', as: :rails_health_check
  post 'upload_app' => 'app#upload_app'
  get 'download_app' => 'app#download_app'

  resources :users

  root 'games#index'
end
