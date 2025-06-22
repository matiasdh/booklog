Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  #
  resources :posts, only: %i[index create] do
    member do
      resources :comments, only: %i[create], controller: "posts/comments", as: :post_comments
      post :like, controller: "posts/likes"
      delete :like, action: :unlike, controller: "posts/likes"
    end
  end

  resources :users, only: %i[show]

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "posts#index"
end
