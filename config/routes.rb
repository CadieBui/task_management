Rails.application.routes.draw do
  namespace :admin do
    resources :users
  end
  resources :sessions
  resources :tasks

  get 'login', to: "sessions#new"
  post 'login', to: "sessions#create"
  delete 'logout', to: "sessions#destroy"

  get "signup", to: "users#new"
  post "signup", to: "users#create"

  root "tasks#index"
end
