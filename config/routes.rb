Rails.application.routes.draw do
  devise_for :users

  root to: "map#index"

  resource :profile, only: [:edit, :update]

  get "map", to: "map#index"
  get "map/search", to: "map#search"

  resources :spots do
    resources :reviews, only: :create
    resources :favourites, only: [:create, :destroy]
    resources :shares, only: :create
  end

  resources :favourites, only: :index
  resource :preference, only: :update

  resources :users, only: [] do
    resources :follows, only: :create
  end

  resources :follows, only: :destroy

  get "community", to: "community#index"

  resources :health_goals do
  resources :chats, only: [:create]
end

resources :chats, only: [:show] do
  resources :messages, only: [:create]
end

  get "up" => "rails/health#show", as: :rails_health_check
end
