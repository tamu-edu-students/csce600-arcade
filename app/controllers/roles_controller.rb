class RolesController < ApplicationController
  def update_roles
    user_roles = params[:user_roles] || {}
    user_roles_games = params[:user_roles_games] || {}

    user_roles.each do |user_id, roles|
      user = User.find(user_id)

      # Remove user if they are not a "Member"
      unless roles.include?("Member")
        user.destroy
        next
      end

      # Manage "System Admin" role
      if roles.include?("System Admin")
        user.roles.find_or_create_by(role: "System Admin")
      else
        SettingsService.remove_role(user, "System Admin")
        user.roles.where(role: "System Admin").destroy_all
      end
    end

    active_user_ids = User.joins(:roles).where(roles: { role: ["Puzzle Setter", "Puzzle Aesthetician"] }).distinct.pluck(:id)
    ids_to_remove = active_user_ids - user_roles_games.keys.map(&:to_i)
    
    ids_to_remove.each do |user_id|
      SettingsService.remove_role(User.find_by(id: user_id), "Puzzle Setter", "any")
      SettingsService.remove_role(User.find_by(id: user_id), "Puzzle Aesthetician", "any")
      User.find(user_id).roles.where(role: ["Puzzle Setter", "Puzzle Aesthetician"]).destroy_all
    end

    user_roles_games.each do |user_id, role_games|
      user = User.find(user_id)

      ["Puzzle Setter"].each do |role|
        unless role_games.key?(role)
          user.roles.where(role: role).destroy_all 
          SettingsService.remove_role(user, "Puzzle Setter", "any")
        end
      end

      ["Puzzle Aesthetician"].each do |role|
        unless role_games.key?(role)
          user.roles.where(role: role).destroy_all 
          SettingsService.remove_role(user, "Puzzle Aesthetician", "any")
        end
      end

      role_games.each do |role, game_names|
        new_game_ids = Game.where(name: game_names).pluck(:id)
        current_roles = user.roles.where(role: role)

        games_to_remove = current_roles.where.not(game_id: new_game_ids)
        games_to_add = new_game_ids - current_roles.pluck(:game_id)
        
        if games_to_remove.any?
          games_to_remove.each do |game_to_remove|
            game_to_remove.destroy
            SettingsService.remove_role(user, game_to_remove.role, game_to_remove.game.name)
          end
        end

        games_to_add.each do |game_id|
          user.roles.create(role: role, game_id: game_id)
        end
      end
    end

    redirect_to users_path, notice: 'Roles updated successfully.'
  end
end