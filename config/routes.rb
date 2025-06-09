Rails.application.routes.draw do
  devise_for :users
  resources :users, only: %i[show edit update]
  resources :posts, only: %i[index show create destroy]

  get "up" => "rails/health#show", as: :rails_health_check

  root "posts#index"
end
