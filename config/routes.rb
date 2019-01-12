Rails.application.routes.draw do
  root to: 'main#home'
  
  namespace :api, defaults: { format: :json } do
    resources :products, only: [:index, :create, :update, :destroy] do
      get 'search', on: :collection
    end
  end

  # Vue fallback
  get "/*path", to: "main#home", format: false
end

