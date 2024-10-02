Rails.application.routes.draw do
  resources :games, only: [:show, :demo_game, :index]
  get "up" => "rails/health#show", as: :rails_health_check
  root :to => redirect('/games')

  ## stub paths to demo game landing page
  get '/spellingbee/:id', to: 'games#demo_game', as: 'spellingbee'
  get '/wordle/:id', to: 'games#demo_game', as: 'wordle'
  get '/letterboxed/:id', to: 'games#demo_game', as: 'letterboxed'
end
