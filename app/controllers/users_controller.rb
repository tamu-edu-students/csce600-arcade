# app/controllers/users_controller.rb
class UsersController < ApplicationController
  def index
    @users = UserService.fetch_all()
  end

  def create
  end

  def show
    if params[:id] == session[:user_id]
      @current_user = UserService.find_user_by_id(params[:id])
    else
      @current_user = UserService.find_user_by_id(session[:user_id])
    end
  end

  def edit
    if params[:id] == session[:user_id]
      @current_user = UserService.find_user_by_id(params[:id])
    else
      @current_user = UserService.find_user_by_id(session[:user_id])
    end
  end

  def update
    if params[:id] == session[:user_id]
      @current_user = UserService.find_user_by_id(params[:id])
    else
      @current_user = UserService.find_user_by_id(session[:user_id])
    end
    @current_user.update!(user_params)
    redirect_to user_path(@current_user), notice: "Account was successfully updated."
  end

  def destroy
    if params[:id] == session[:user_id]
      @current_user = UserService.find_user_by_id(params[:id])
    else
      @current_user = UserService.find_user_by_id(session[:user_id])
    end
    @current_user.destroy!
    reset_session
    redirect_to welcome_path, notice: "Account successfully deleted"
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name)
  end
end
