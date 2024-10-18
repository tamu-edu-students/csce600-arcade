# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins 'https://csce606arcade-12ac8dd4dc24.herokuapp.com' 
      resource '*',
        headers: :any,
        methods: [:get, :post, :options],
        credentials: true
    end
  
    allow do
      origins 'http://127.0.0.1:3000' 
      resource '*',
        headers: :any,
        methods: [:get, :post, :options],
        credentials: true
    end
  end