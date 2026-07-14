Rails.application.routes.draw do
  devise_for :users

  root to: "pages#home"

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

  get "up" => "rails/health#show", as: :rails_health_check
end
