class RolesController < ApplicationController
  def update_roles
    # Non Game Based Roles
    params[:user_roles].each do |user_id, roles|
      user = User.find(user_id)

      settings = Settings.find_by!(user_id: user_id)

      user.roles.destroy_all  # Remove existing roles
      settings.roles.clear
      settings.save

      roles.each do |role_name|
        new_role = Role.create(user: user, role: role_name)
      end
    end

    # Game Based Roles - Puzzle Setter and Puzzle Aesthetician
    # "user_roles_games"=>{"7"=>{"Puzzle Setter"=>["Letter Boxed"]}}
    if params[:user_roles_games].present?
      params[:user_roles_games].each do |user_id, roles|
        user = User.find(user_id)

        roles.each do |role_name, games|
          games.each do |game_name|
            game_id = Game.find_by(name: game_name).id
            role = Role.create(user: user, role: role_name, game_id: game_id)
          end
        end
      end
    end
    # Redirect after all roles have been processed
    redirect_to users_path, notice: "Roles updated successfully!"
  end
end
