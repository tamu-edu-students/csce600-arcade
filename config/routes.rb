# config/routes.rb
Rails.application.routes.draw do
    root "welcome#index"

    get "welcome/index", as: "welcome"
    get "welcome/guest", as: "guest"

    get "sessions/logout", to: "sessions#logout", as: "logout"
    get "sessions/omniauth", to: "sessions#omniauth"
    
    get "/auth/google_oauth2/callback", to: "sessions#omniauth"
    get "/auth/github/callback", to: "sessions#github"
    get "/auth/spotify/callback", to: "sessions#spotify"

    resources :users

    resources :games, param: :id
    get "spellingbee/:id", to: "games#spellingbee", as: "spellingbee"
    post "spellingbee/:id", to: "games#spellingbee"
    get "/wordle/:id", to: "games#demo_game", as: "wordle"
    get "/letterboxed/:id", to: "games#demo_game", as: "letterboxed"

    resources :aesthetics, param: :game_id
    
    get "dashboard", to: "dashboard#show", as: "dashboard"

    get "up", to: "rails/health#show", as: :rails_health_check
end