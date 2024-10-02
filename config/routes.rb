Rails.application.routes.draw do
  resources :games
  root :to => redirect('/games')

  ## stub paths to demo game landing page
  get '/spellingbee/:id', to: 'games#demo_game', as: 'spellingbee'
  get '/wordle/:id', to: 'games#demo_game', as: 'wordle'
  get '/letterboxed/:id', to: 'games#demo_game', as: 'letterboxed'
end
