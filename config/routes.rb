Rails.application.routes.draw do
  root "sessions#new"
  resources :items
  resources :users

  get "/register", to: "users#new"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
end
