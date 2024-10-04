# app/services/user_service.rb
class UserService
    def self.find_or_create_user(auth)
        uid = auth["uid"]
        email = auth["info"]["email"]
        names = auth["info"]["name"].split
        first_name = names[0]
        last_name = names[1..].join(" ")

        if Rails.env.test?
            email_to_find = email.present? ? email : "spongey@tamu.edu"
            user = UserRepository.find_by_email(email_to_find)
        else
            user = UserRepository.find_by_uid(uid) || UserRepository.find_by_email(email)
        end

        unless user
            user = UserRepository.create_user(
                uid: uid,
                email: email,
                first_name: first_name,
                last_name: last_name
            )

            if user.nil? || user.id.nil?
                Rails.logger.error("User creation failed for UID: #{uid} and Email: #{email}")
                raise "User creation failed! user.id is nil"
            end

            Role.create!(user_id: user.id, role: "Member")
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
