  # config/initializers/cors.rb
  Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins "http://localhost:3000",
              "http://127.0.0.1:3000",
              "https://rack-cors-roda.herokuapp.com"

      resource "*",
        headers: :any,
        methods: [ :get, :post, :put, :patch, :delete, :options, :head ],
        credentials: true,
        max_age: 86400
    end
  end

