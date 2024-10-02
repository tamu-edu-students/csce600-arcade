# app/services/user_service.rb
class UserService
    def initialize(user_repo)
        @user_repo = user_repo
    end

    def find_or_create_user(params)
        user = @user_repo.find_by_email(params[:email])
        return user if user

        @user_repo.create(params)
    end

    def update_user(id, params)
        @user_repo.update(id, params)
    end

    def delete_user(id)
        @user_repo.delete(id)
    end

    def logout_user(id)
        @user_repo.logout(id)
    end
end
