Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'main#home'

  resources :products, only: [:create, :update, :destroy]

  # Vue fallback
  get "/*path", to: "main#home", format: false
end

