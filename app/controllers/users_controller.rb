# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :check_session_id_admin, only: %i[ index ]

  def index
    @users = UserService.fetch_all()
  end

  def create
  end

  def show
    @settings = Settings.find_by(user_id: session[:user_id]) if session[:user_id]
    @roles = Role.where(user_id: session[:user_id]) if session[:user_id]
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
  def check_session_id_admin
    all_sys_admin = Role.where(role: "System Admin")
    if all_sys_admin.empty? || session[:user_id].nil?
      redirect_to "#", alert: "You are not authorized to access this page - 1."
    elsif all_sys_admin.map { |r| r.user_id }.exclude? session[:user_id]
      redirect_to "#", alert: "You are not authorized to access this page. - 2"
    end
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :github_username, :email, :spotify_username)
  end
end
