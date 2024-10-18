# config/initializers/cors.rb
  Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins "http://localhost:4000",
              "http://127.0.0.1:4000",
              "https://csce606arcade-12ac8dd4dc24.herokuapp.com"
  
      resource "*",
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head],
        credentials: true,
        max_age: 86400
    end
  end