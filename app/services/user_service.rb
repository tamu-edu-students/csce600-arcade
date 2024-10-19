# app/services/user_service.rb
class UserService
    def self.find_or_create_user(auth)
        email = auth["info"]["email"]
        names = auth["info"]["name"].split
        first_name = names[0]
        last_name = names[1..].join(" ")

        if Rails.env.test?
            email = email.present? ? email : "spongey@tamu.edu"
        end

        user = UserRepository.find_by_email(email)

        unless user
            user = UserRepository.create_user(
                email: email,
                first_name: first_name,
                last_name: last_name
            )

            Role.create!(user_id: user.id, role: "Member")
            Settings.create!(user_id: user.id, active_roles: "Member")
        end

        user
    end

    def self.github_user(auth)
        github_username = auth["info"]["nickname"]
        if auth["info"]["name"]
            names = auth["info"]["name"].split
        else
            names = "Hello"
        end
        first_name = names[0]
        last_name = names[1..].join(" ") || "User"

        user = UserRepository.find_by_gu(github_username)

        unless user
            user = UserRepository.create_github(
                github_username: github_username,
                first_name: first_name,
                last_name: last_name
            )
            puts user
            puts user.id
            Role.create!(user_id: user.id, role: "Member")
            Settings.create!(user_id: user.id, active_roles: "Member")
        end

        user
    end

    def self.spotify_user(auth)
        spotify_username = auth["extra"]["raw_info"]["id"]
        names = auth["extra"]["raw_info"]["display_name"] || "User"
        name_parts = names.split(" ")
        first_name = name_parts[0] || "User"
        last_name = name_parts[1] || ""

        if !spotify_username.nil?
            user = UserRepository.find_by_su(spotify_username)
        end

        unless user
            user = UserRepository.create_spotify(
                spotify_username: spotify_username,
                first_name: first_name,
                last_name: last_name
            )
            Role.create!(user_id: user.id, role: "Member")
            Settings.create!(user_id: user.id, active_roles: "Member")
        end

        user
    end

    def self.find_user_by_id(id)
        UserRepository.find_by_id(id)
    end

    def self.fetch_all
        UserRepository.fetch_all
    end
end
