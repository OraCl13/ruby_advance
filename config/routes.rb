# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper
  default_url_options host: 'localhost'
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks',
                                    confirmations: 'confirmations' }

  resources :questions do
    resources :answers do
      resources :comments
      post :position_edit, :cancel_choice
    end
    resources :comments
  end

  namespace :api do
    namespace :v1 do
      resource :profiles do
        get :me, on: :collection
        get :users, on: :collection
      end
      resources :questions do
        resources :answers
      end
    end
  end

  root to: 'questions#index'
  mount ActionCable.server => '/cable'
end
