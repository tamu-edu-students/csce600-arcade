class RolesController < ApplicationController
  def update_roles
    puts "Params: #{params.inspect}"  # Debugging statement to check params being passed

    # Non Game Based Roles
    params[:user_roles].each do |user_id, roles|
      user = User.find(user_id)
      active_roles = SettingsService.get_active_roles user_id
      active_role_names = []
      active_roles.each do |role|
        active_role_names << role.role
      end

      settings = Settings.find_by(user_id: user_id)

      user.roles.destroy_all  # Remove existing roles
      settings.roles.clear
      settings.save

      roles.each do |role_name|
        new_role = Role.create(user: user, role: role_name)
        settings.roles << new_role.id if active_role_names.include? role_name
      end
      settings.save
    end

    # Game Based Roles - Puzzle Setter and Puzzle Aesthetician
    # "user_roles_games"=>{"7"=>{"Puzzle Setter"=>["Letter Boxed"]}}
    if params[:user_roles_games].present?
      params[:user_roles_games].each do |user_id, roles|
        user = User.find(user_id)

        settings = Settings.find_by(user_id: user_id)
        active_roles = SettingsService.get_active_roles user_id
        puts active_roles
        active_role_attributes = []
        active_roles.each do |role|
          if [ "Puzzle Aesthetician", "Puzzle Setter" ].include? role.role
            settings.roles.delete(role.role)
            active_role_attributes << [ role.role, role.game_id ]
          end
        end
        settings.save

        roles.each do |role_name, games|
          games.each do |game_name|
            game_id = Game.find_by(name: game_name).id
            role = Role.create(user: user, role: role_name, game_id: game_id)
            settings.roles << role.id if active_role_attributes.include? [ role_name, game_id ]
          end
        end
        settings.save
      end
    end
    # Redirect after all roles have been processed
    redirect_to users_path, notice: "Roles updated successfully!"
  end
end
