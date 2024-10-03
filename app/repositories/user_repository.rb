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

    def self.create_user(uid:, email:, first_name:, last_name:, role_id:)
        User.create(uid: uid, email: email, first_name: first_name, last_name: last_name, role_id: role_id)
    end
end
