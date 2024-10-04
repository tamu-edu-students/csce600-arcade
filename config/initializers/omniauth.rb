Rails.application.config.middleware.use OmniAuth::Builder do
    # Retrieve Google credentials from environment variables
    provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], {
        scope: "email, profile", # This grants access to the user's email and profile information.
        prompt: "select_account", # This allows users to choose the account they want to log in with.
        image_aspect_ratio: "square", # Ensures the profile picture is a square.
        image_size: 50 # Sets the profile picture size to 50x50 pixels.
    }
end