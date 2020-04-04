Rails.application.routes.draw do
  # AWS s3 presign
  mount Shrine.presign_endpoint(:cache) => "/presign"

  root to: 'main#home'

  namespace :api, defaults: { format: :json } do
    post 'user_token' => 'user_token#create'

    resources :users, only: :update

    resources :products, only: [:index] do
      get 'search', on: :collection
    end

    namespace :admin do
      resources :brands, only: [:index, :create, :update]
      resources :products, only: [:index, :create, :update, :destroy]
      resources :users, only: [:index, :create]
    end
  end

  # Vue fallback
  get "/*path", to: "main#home", format: false
end

