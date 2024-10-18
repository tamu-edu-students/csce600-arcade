# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :check_session_id_admin, only: %i[ index ]

  def index
    @users = UserService.fetch_all()
    @all_roles = Role.all_roles  # Call the class method to get all roles
    @all_games = Game.pluck(:name)  # Call the class method to get all games
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
      user.roles.destroy_all  # Remove existing roles
      roles.each do |role_name|
        if ["Puzzle Setter", "Puzzle Aesthetician"].include?(role_name)
          if params[:user_roles_games].nil? || params[:user_roles_games][user_id].nil?
            # If no games are selected for this role, redirect with a notice
            redirect_to users_path, alert: "Please select at least one game for Puzzle Setter or Puzzle Aesthetician" and return
          end
          
          games = params[:user_roles_games][user_id][role_name] || []
          
  
          # Create roles with associated games
          games.each do |game_name|
            game = Game.find_by(name: game_name)
            puts "Game: #{game_name}"
            Role.create(user: user, role: role_name, game: game)
          end
        else
          # Handle roles without games
          Role.create(user: user, role: role_name)
        end
      end
    end
    redirect_to users_path, notice: "Roles updated successfully!"
  end

  private
  def check_session_id_admin
    all_sys_admin = Role.where(role: "System Admin")
    if all_sys_admin.empty? || session[:user_id].nil?
      redirect_to "#", alert: "You are not authorized to access this page."
    elsif all_sys_admin.map { |r| r.user_id }.exclude? session[:user_id]
      redirect_to "#", alert: "You are not authorized to access this page."
    end
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :github_username, :email, :spotify_username)
  end
end
