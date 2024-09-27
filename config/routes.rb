Rails.application.routes.draw do
  # Define the root path route ("/")
  root "pages#index"  # This sets "pages#index" as the root path

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check
end
