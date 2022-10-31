Rails.application.routes.draw do
  resources :sessions
  resources :users
  resources :tasks

  get 'login', to: "sessions#new"
  post 'login', to: "sessions#create"
  delete 'logout', to: "sessions#destroy"

  get 'admin', to: "users#index"
  
  get "signup",to: "users#new"
  post "signup",to: "users#create"

  root "tasks#index"
end
