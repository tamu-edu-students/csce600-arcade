# app/services/user_service.rb
# Handles information extraction from OAuth.
class UserService
    def self.fetch_connected_auths(user)
        # Dictionary to hold all connected auths
        auths = {}
        if user.github_username
            auths["github"] = user.github_username
        end
        if user.spotify_username
            auths["spotify"] = user.spotify_username
        end
        if user.email
            auths["email"] = user.email
        end
        auths
    end
end