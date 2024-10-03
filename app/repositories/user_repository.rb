# app/repositories/user_repository.rb
class UserRepository
    def self.find_by_uid(uid)
        User.find_by(uid: uid)
    end

    def self.create_user(uid:, email:, first_name:, last_name:)
        User.create(uid: uid, email: email, first_name: first_name, last_name: last_name)
    end
end
