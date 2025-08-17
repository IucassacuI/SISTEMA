Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  get "up" => "rails/health#show", as: :rails_health_check

  resources :announcements
  resources :users
  resources :messages

  root "announcements#index"

  get "login", to: "sessions#new"
  get "chat", to: "messages#index"
end
