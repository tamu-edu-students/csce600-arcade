# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :check_session_id_admin, only: %i[ index ]

  def index
    @all_roles = Role.all
    @all_games = Game.where.not(id: -1).pluck(:name)
  
    if params[:search].present?
      # Downcase search term for case-insensitive matching
      search_term = params[:search].downcase
      puts "Search term:"
      puts search_term
      # Join users to roles and roles to games, so we can search across all associated fields
      @users = User.left_joins(roles: :game) # Left joins to include users even without roles or games
              .where("LOWER(users.first_name) LIKE :search 
                      OR LOWER(users.last_name) LIKE :search 
                      OR LOWER(roles.role) LIKE :search
                      OR LOWER(games.name) LIKE :search", search: "%#{search_term}%")
              .distinct
    else
      # Load all users if no search term is provided
      @users = User.all
    end
  end
  

  def create
  end

  def show
    @settings = Settings.find_by(user_id: session[:user_id])
    @roles = Role.where(user_id: session[:user_id])
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
      redirect_to "#", alert: "You are not authorized to access this page."
    elsif all_sys_admin.map { |r| r.user_id }.exclude? session[:user_id]
      redirect_to "#", alert: "You are not authorized to access this page."
    end
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :github_username, :email, :spotify_username)
  end
end
