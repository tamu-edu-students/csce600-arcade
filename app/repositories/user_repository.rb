# app/repositories/user_repository.rb
class UserRepository
    def self.find_by_uid(uid)
        User.find_by(uid: uid)
    end

    def self.find_by_id(id)
        User.find_by(id: id)
    end

    def self.find_by_email(email)
        User.find_by(email: email)
    end

    def self.find_by_gu(gu)
        User.find_by(github_username: gu)
    end

    def self.find_by_su(su)
        User.find_by(spotify_username: su)
    end

    def self.create_user(uid:, email:, first_name:, last_name:)
        User.create(uid: uid, email: email, first_name: first_name, last_name: last_name)
    end

    def self.create_github(uid:, github_username:, first_name:, last_name:)
        User.create(uid: uid, github_username: github_username, first_name: first_name, last_name: last_name)
    end

    def self.create_spotify(uid:, spotify_username:, first_name:, last_name:)
        User.create(uid: uid, spotify_username: spotify_username, first_name: first_name, last_name: last_name)
    end

    def self.fetch_all
        User.all
    end
end
