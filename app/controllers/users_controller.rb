# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :check_session_id_admin, only: %i[ index ]

  def index
    @users = UserService.fetch_all()
    @all_roles = Role.all_roles  # Call the class method to get all roles
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

  def update_roles
    params[:user_roles].each do |user_id, roles|
      user = User.find(user_id)
      puts "User ID: #{user_id}"
      puts "Roles: #{roles}"
      puts "User: #{user.first_name}"
      user.roles.destroy_all  # Remove existing roles
      roles.each do |role_name|
        Role.create(user: user, role: role_name)  # Create new roles
      end
    end
    redirect_to users_path, notice: "Roles updated successfully!"
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
    params.require(:user).permit(:first_name, :last_name)
  end
end
