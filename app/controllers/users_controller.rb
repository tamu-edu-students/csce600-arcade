# app/controllers/users_controller.rb
class UsersController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [ :create_from_external, :update, :destroy, :logout ]
    def initialize
        @user_service = UserService.new(UserRepository.new)
    end

    # create user from external (Oauth)
    def create_from_external
        user_data = params[:user]
        user = @user_service.find_or_create_user(user_data)
        if user
            render json: { message: "User added successfully", user: user }
        else
            render json: { message: "User addition failed" }, status: :unprocessable_entity
        end
    end

    # update user
    def update
        user = @user_service.update_user(params[:id], user_params)
        if user
            render json: { message: "User updated successfully", user: user }
        else
            render json: { message: "User update failed" }, status: :unprocessable_entity
        end
    end

    # delete user
    def destroy
        if @user_service.delete_user(params[:id])
            render json: { message: "User deleted successfully" }
        else
            render json: { message: "User deletion failed" }, status: :unprocessable_entity
        end
    end

    # logout
    def logout
        if @user_service.logout_user(params[:id])
            render json: { message: "Logged out successfully" }
        else
            render json: { message: "Logout failed" }, status: :unprocessable_entity
        end
    end

    private

    def user_params
        params.require(:user).permit(:name, :email, :session, :roleId)
    end
end
