Rails.application.routes.draw do
  default_url_options host: "localhost"
  devise_for :users

  resources :questions do
    resources :answers do
      resources :comments
      post :position_edit, :cancel_choice
    end
    resources :comments
  end
  root to: "questions#index"
  mount ActionCable.server => '/cable'
end
