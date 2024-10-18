class RolesController < ApplicationController
  
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
end
