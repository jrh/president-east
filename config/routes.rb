Rails.application.routes.draw do
  # AWS s3 presign
  mount Shrine.presign_endpoint(:cache) => "/presign"

  root to: 'main#home'

  namespace :api, defaults: { format: :json } do
    post 'login', to: 'authentication#create'
    resources :users, only: [:index, :create]
    resources :products, only: [:index, :create, :update, :destroy] do
      get 'search', on: :collection
    end
  end

  # Vue fallback
  get "/*path", to: "main#home", format: false
end

