# config/routes.rb
Rails.application.routes.draw do
  root "welcome#index"

  get "welcome/index", to: "welcome#index", as: "welcome"
  get "welcome/guest", as: "guest"

  get "sessions/logout", to: "sessions#logout", as: "logout"
  get "sessions/omniauth", to: "sessions#omniauth"

  get "/auth/google_oauth2/callback", to: "sessions#omniauth"
  get "/auth/github/callback", to: "sessions#github"
  get "/auth/spotify/callback", to: "sessions#spotify"

  resources :users do
    get :roles, to: "roles#index"
  end

  resources :games, param: :id
  get "/bees/play", to: "bees#play", as: "bees_play"
  resources :bees, except: [ :new ] do
    collection do
      post "submit_guess"
    end
  end
  get "/wordles/play", to: "wordles#play", as: "wordles_play"
  resources :wordles
  get "/letterboxed/:id", to: "games#demo_game", as: "letterboxed"

  post "settings/update"

  get "up", to: "rails/health#show", as: :rails_health_check

  resources :aesthetics, param: :game_id
  patch 'aesthetics/:id/reload_demo', to: 'aesthetics#reload_demo', as: 'reload_demo'

  get "dashboard", to: "dashboard#show", as: "dashboard"

  resources :roles
  resources :roles do
    post :update_roles, on: :collection
  end

  resources :settings, only: [ :update ]

  resources :games
  resources :users
end
