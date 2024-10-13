# app/controllers/users_controller.rb
class UsersController < ApplicationController
  def index
    @users = UserService.fetch_all()
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
    @current_user.update!(user_params)
    redirect_to user_path(@current_user), notice: "Account was successfully updated."
  end

  def destroy
    @current_user.destroy!
    reset_session
    redirect_to welcome_path, notice: "Account successfully deleted"
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :github_username, :email)
  end
end
