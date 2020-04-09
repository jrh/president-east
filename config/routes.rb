# frozen_string_literal: true
Rails.application.routes.draw do

  mount Shrine.presign_endpoint(:cache) => "/s3/params"

  root to: 'main#home'

  namespace :api, defaults: { format: :json } do
    post 'login' => 'sessions#create'
    delete 'logout' => 'sessions#destroy'

    resources :passwords, only: [:new, :create] do
      collection do
        get ':token/edit', action: :edit, as: :edit
        patch ':token', action: :update
      end
    end

    resources :users, only: [:show, :update]

    resources :products, only: [:index, :show] do
      get 'search', on: :collection
    end

    namespace :admin do
      resources :brands, only: [:index, :create, :update]
      resources :products, only: [:index, :create, :update, :destroy]
      resources :users, only: [:index, :create, :update]
    end
  end

  # Vue fallback
  get "/*path", to: "main#home", format: false
end

