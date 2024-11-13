# config/routes.rb
Rails.application.routes.draw do
  root "welcome#index"

  get "welcome/index", to: "welcome#index", as: "welcome"
  get "welcome/guest", as: "guest"

  get "sessions/logout", to: "sessions#logout", as: "logout"
  get "sessions/omniauth", to: "sessions#omniauth"

  get "/auth/google_oauth2/callback", to: "sessions#omniauth"
  get "/auth/github/callback", to: "sessions#omniauth"
  get "/auth/spotify/callback", to: "sessions#omniauth"

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

  get "/boxes/play", to: "boxes#play", as: "boxes_play"
  resources :boxes, except: [ :new ] do
    collection do
      post "submit_word"
      post "paths"
      get "reset"
    end
  end

  resources :letter_boxes, controller: :boxes

  get "/games/demo_game", to: "games#demo_game", as: "demo_game"

  post "/settings/update"
  post "/settings/update_settings/:id", to: "settings#update_settings", as: "update_settings"

  get "up", to: "rails/health#show", as: :rails_health_check

  resources :aesthetics, param: :id
  patch "aesthetics/:id/reload_demo", to: "aesthetics#reload_demo", as: "reload_demo"

  get "dashboard", to: "dashboard#show", as: "dashboard"

  patch "/wordle_dictionaries/amend_dict", to: "wordle_dictionaries#amend_dict", as: "amend_dict"
  patch "/wordle_dictionaries/reset_dict", to: "wordle_dictionaries#reset_dict", as: "reset_dict"

  resources :roles
  resources :roles do
    delete :destroy_many, on: :collection
    post :update_roles, on: :collection
  end

  resources :settings, only: [ :update, :update_wordle_settings ]

  resources :games
  resources :users
  resources :wordle_dictionaries, only: [:index]

  get "/game_2048/play", to: "game_2048#play", as: "game_2048_play"
  resources :game_2048 do
    collection do
      post "make_move"
      post "new_game"
    end
  end
  namespace :game_2048 do
    resources :aesthetics, only: [ :edit, :update ] do
      member do
        patch :preview
      end
    end
  end
end
