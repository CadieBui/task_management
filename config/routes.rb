Rails.application.routes.draw do
  resources :sessions
  get 'login', to: "sessions#new"
  post 'login', to: "sessions#create"

  delete 'logout', to: "session#destroy"

  resources :users
  resources :tasks
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get "signup",to: "users#new"
  post "signup",to: "users#create"

  # Defines the root path route ("/")
  root "tasks#index"
end
