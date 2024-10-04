# app/controllers/users_controller.rb
class UsersController < ApplicationController
  def index
    @users = UserService.fetch_all()
  end

  def show
    @current_user = UserService.find_user_by_id(params[:id])
  end

  def edit
  end

  def destroy
    @current_user = UserService.find_user_by_id(params[:id])
    @current_user.destroy!
    redirect_to logout_path, notice: "Account successfully deleted"
  end
end
