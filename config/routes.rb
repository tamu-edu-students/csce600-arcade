# config/routes.rb
Rails.application.routes.draw do
  scope "/api" do
    resources :users, only: [ :update, :destroy ]

    post "users/create_from_external", to: "users#create_from_external"

    post "users/:id/logout", to: "users#logout"
  end
end
