class RolesController < ApplicationController
  # before_action :check_session_id_admin, only: %i[ index ]
  def index
    if params[:user_id].nil?
      redirect_to games_path
    else
      @managing_user ||= User.find(params[:user_id])
    end
  end

  def destroy
    @managing_user = User.find(params[:user_id])
    if params[:id] == "destroy_many"
      role = Role.where(role: params[:role], user_id: @managing_user.id).destroy_all
      SettingsService.remove_role(@managing_user, params[:role], "any")
    else
      role = Role.find(params[:id])
      SettingsService.remove_role(@managing_user, role.role, role.game ? role.game.name : "")
      role.destroy!
    end
    redirect_to roles_path(user_id: @managing_user.id), notice: "Removed role from user"
  end

  def create
    @managing_user = User.find(params[:user_id])
    if params[:game]
      game = Game.find_by(name: params[:game])
      Role.create!(role: params[:role], user_id: @managing_user.id, game_id: game.id)
    else
      Role.create!(role: params[:role], user_id: @managing_user.id)
    end
    redirect_to roles_path(user_id: @managing_user.id), notice: "Assigned role to user"
  end

  def update_roles
    user_roles = params[:user_roles] || {}
    user_roles_games = params[:user_roles_games] || {}

    user_roles.each do |user_id, roles|
      user = User.find(user_id)
      process_user_roles(user, roles)
    end

    remove_inactive_users(user_roles_games)

    user_roles_games.each do |user_id, role_games|
      user = User.find(user_id)
      update_role_games(user, role_games)
    end

    redirect_to users_path, notice: "Roles updated successfully."
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

  def process_user_roles(user, roles)
    roles.include?("Member") ? manage_role(user, roles, "System Admin") : user.destroy
  end

  def remove_inactive_users(user_roles_games)
    active_user_ids = User.joins(:roles).where(roles: { role: [ "Puzzle Setter", "Puzzle Aesthetician" ] }).distinct.pluck(:id)
    ids_to_remove = active_user_ids - user_roles_games.keys.map(&:to_i)

    ids_to_remove.each do |user_id|
      user = User.find_by(id: user_id)
      remove_roles(user, [ "Puzzle Setter", "Puzzle Aesthetician" ]) if user
    end
  end

  def update_role_games(user, role_games)
    [ "Puzzle Setter", "Puzzle Aesthetician" ].each do |role|
      role_games[role] ? update_user_role_games(user, role, role_games[role]) : remove_roles(user, [ role ])
    end
  end

  def manage_role(user, roles, role_name)
    if roles.include?(role_name)
      user.roles.find_or_create_by(role: role_name)
    else
      SettingsService.remove_role(user, role_name)
      user.roles.where(role: role_name).destroy_all
    end
  end

  def remove_roles(user, roles)
    roles.each do |role|
      SettingsService.remove_role(user, role, "any")
      user.roles.where(role: role).destroy_all
    end
  end

  def update_user_role_games(user, role, game_names)
    new_game_ids = Game.where(name: game_names).pluck(:id)
    current_roles = user.roles.where(role: role)

    games_to_remove = current_roles.where.not(game_id: new_game_ids)
    games_to_add = new_game_ids - current_roles.pluck(:game_id)

    games_to_remove.each do |role_to_remove|
      SettingsService.remove_role(user, role_to_remove.role, role_to_remove.game.name)
      role_to_remove.destroy
    end

    games_to_add.each do |game_id|
      user.roles.create(role: role, game_id: game_id)
    end
  end
end
