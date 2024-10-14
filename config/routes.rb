# config/routes.rb
Rails.application.routes.draw do
  # root and health check
  root "welcome#index"
  get "up" => "rails/health#show", as: :rails_health_check

  # routes to facilitate login/logout and guest session setting
  get "welcome/index", to: "welcome#index", as: "welcome"
  get "welcome/guest", to: "welcome#guest", as: "guest"
  get "/logout", to: "sessions#logout", as: "logout"
  get "/auth/google_oauth2/callback", to: "sessions#omniauth"

  # users controller routes
  get "users/show"
  get "/users/:id", to: "users#show", as: "user"

  # routes for the various games
  get "/wordles/play", to: "wordles#play", as: "wordles_play"

  get "/spellingbee/:id", to: "games#demo_game", as: "spellingbee"
  get "/letterboxed/:id", to: "games#demo_game", as: "letterboxed"

  # user game statistics routes
  get "dashboard", to: "dashboard#show", as: "dashboard"

  # user settings routes
  post "settings/update"

  resources :users do # nested routes for roles for all users
    collection do
      post :update_roles  
    end
  end

  resources :settings, only: [:update] # Update settings for the current user
  # auto generated rails controller based routes
  resources :games
  resources :users
  resources :wordles
end
