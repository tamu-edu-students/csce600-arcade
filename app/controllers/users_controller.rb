# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :check_session_id_admin, only: %i[ index ]

  def index
    @all_roles = Role.all
    @all_games = Game.where.not(id: -1).pluck(:name)
  
    # Base query to fetch users
    if params[:search].present?
      search_term = params[:search].downcase
      @users = User.left_joins(roles: :game)
                   .where("LOWER(users.first_name) LIKE :search 
                           OR LOWER(users.last_name) LIKE :search 
                           OR LOWER(roles.role) LIKE :search
                           OR LOWER(games.name) LIKE :search", search: "%#{search_term}%")
                   .distinct
    else
      @users = User.all
    end
  
    # Collect user IDs based on filters
    filtered_user_ids = Set.new
  
    # Apply role filters if provided
    if params[:roles].present?
      role_user_ids = Role.where(role: params[:roles]).pluck(:user_id)
      filtered_user_ids.merge(role_user_ids)
    end
  
    # Apply game filters if provided
    if params[:games].present?
      params[:games].each do |role, games|
        game_user_ids = Role.joins(:game)
                            .where(role: role, games: { name: games })
                            .pluck(:user_id)
        filtered_user_ids.merge(game_user_ids)
      end
    end
  
    # Retrieve users matching the collected user IDs
    if filtered_user_ids.any?
      @users = User.where(id: filtered_user_ids)
    elsif params[:roles].present? || params[:games].present?
      # If filters yield no results, display all users and show a warning
      flash[:alert] = "No users match the selected filters. Displaying all users instead."
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
