# config/routes.rb
Rails.application.routes.draw do
    get "sessions/logout"
    get "sessions/omniauth"
    get "users/show"
    get "welcome/index"

    root "welcome#index"

    get "welcome/index", to: "welcome#index", as: "welcome"
    get 'welcome/guest', to: 'welcome#guest', as: 'guest'

    get "/users/:id", to: "users#show", as: "user"
    get "/logout", to: "sessions#logout", as: "logout"
    get "/auth/google_oauth2/callback", to: "sessions#omniauth"

    resources :games

    get "up" => "rails/health#show", as: :rails_health_check

    get "/spellingbee/:id", to: "games#demo_game", as: "spellingbee"
    get "/wordle/:id", to: "games#demo_game", as: "wordle"
    get "/letterboxed/:id", to: "games#demo_game", as: "letterboxed"
end
