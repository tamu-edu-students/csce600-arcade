# app/services/user_service.rb
class UserService
    def self.find_or_create_user(auth)
        uid = auth["uid"]
        email = auth["info"]["email"]
        names = auth["info"]["name"].split
        first_name = names[0]
        last_name = names[1..].join(" ")

        user = UserRepository.find_by_uid(uid)

        unless user
            user = UserRepository.create_user(
                uid: uid,
                email: email,
                first_name: first_name,
                last_name: last_name
            )
        end

        user
    end

    def self.find_user_by_id(id)
        UserRepository.find_by_id(id)
    end
end
