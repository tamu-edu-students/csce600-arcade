class RolesController < ApplicationController
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
