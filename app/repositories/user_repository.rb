# app/repositories/user_repository.rb
class UserRepository
    def find_by_email(email)
        User.find_by(email: email)
    end

    def create(params)
        permitted_params = params.permit(:name, :email, :session, :roleId)
        User.create(permitted_params)
    end

    def update(id, params)
        user = User.find_by(id: id)
        return nil unless user

        user.update(params)
        user
    end

    def delete(id)
        user = User.find_by(id: id)
        return false unless user

        user.destroy
    end

    def logout(id)
        user = User.find_by(id: id)
        return false unless user

        user.update(session: nil)
    end
end
