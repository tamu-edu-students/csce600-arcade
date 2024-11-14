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

  patch "/wordle_valid_solutions/add_solutions", to: "wordle_valid_solutions#add_solutions", as: "add_solutions"
  patch "/wordle_valid_solutions/overwrite_solutions", to: "wordle_valid_solutions#overwrite_solutions", as: "overwrite_solutions"
  patch "/wordle_valid_solutions/reset_solutions", to: "wordle_valid_solutions#reset_solutions", as: "reset_solutions"

  patch "/wordle_valid_guesses/add_guesses", to: "wordle_valid_guesses#add_guesses", as: "add_guesses"
  patch "/wordle_valid_guesses/overwrite_guesses", to: "wordle_valid_guesses#overwrite_guesses", as: "overwrite_guesses"
  patch "/wordle_valid_guesses/reset_guesses", to: "wordle_valid_guesses#reset_guesses", as: "reset_guesses"

  resources :roles
  resources :roles do
    delete :destroy_many, on: :collection
    post :update_roles, on: :collection
  end

  resources :settings, only: [ :update, :update_wordle_settings ]

  resources :games
  resources :users
  resources :wordle_valid_solutions
  resources :wordle_valid_guesses

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
