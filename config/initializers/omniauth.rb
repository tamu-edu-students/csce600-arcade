Rails.application.config.middleware.use OmniAuth::Builder do
    provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"], {
        scope: "email, profile",
        prompt: "select_account",
        image_aspect_ratio: "square",
        image_size: 50
    }
    provider :github, ENV['GITHUB_CLIENT_ID'], ENV['GITHUB_CLIENT_SECRET'], {
        scope: 'user,public_repo'
    }
    provider :spotify, ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'], {
    scope: 'playlist-read-private user-read-private'
  }
end
