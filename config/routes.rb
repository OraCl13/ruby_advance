Rails.application.routes.draw do
  default_url_options host: "localhost"
  devise_for :users

  resources :questions do
    resources :answers
  end
  root to: "questions#index"
end
