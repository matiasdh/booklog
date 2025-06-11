Rails.application.routes.draw do
  devise_for :users
  resources :users, only: %i[show edit update]
  resources :posts, only: %i[index show create destroy] do
    member do
      resources :comments, only: %i[create], controller: "posts/comments", as: :post_comments
      post :like, controller: "posts/likes"
      delete :like, action: :unlike, controller: "posts/likes"
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "posts#index"
end
