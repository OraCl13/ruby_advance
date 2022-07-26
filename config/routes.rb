Rails.application.routes.draw do
  default_url_options host: "localhost"
  devise_for :users

  resources :questions do
    resources :answers do
      post :make_best
    end
  end
  root to: "questions#index"
end
