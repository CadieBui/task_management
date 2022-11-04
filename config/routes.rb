Rails.application.routes.draw do
  get 'admin', to: "users#index"
  get 'admin/new', to: "users#new_by_admin"
  post 'admin/new', to: "users#create_by_admin"

  resources :sessions
  resources :users
  resources :tasks

  get 'login', to: "sessions#new"
  post 'login', to: "sessions#create"
  delete 'logout', to: "sessions#destroy"

  get "signup", to: "users#new"
  post "signup", to: "users#create"

  root "tasks#index"
end
