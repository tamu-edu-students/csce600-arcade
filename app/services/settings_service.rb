# app/services/settings_service.rb
class SettingsService
  def self.role_exists?(user, role, game = "")
    settings = Settings.find_by(user_id: user.id)

    return false unless settings&.active_roles.present?

    active_roles_array = settings.active_roles.split(",").map(&:strip)

    if game.present?
      active_roles_array.each do |active_role_info|
        if active_role_info.include?("-")
          active_role, active_game = active_role_info.split("-")
          if active_role.include?(role) && active_game.include?(game.name)
            return true
          end
        end
      end
    else
      return active_roles_array.include?(role)
    end

    false
  end

  def self.remove_role(user, role, game = "")
    settings = Settings.find_by(user_id: user.id)
    if !game.present?
      current_roles = settings.active_roles.split(",")
      if current_roles.include?(role)
        current_roles.delete(role)
        settings.active_roles = current_roles.join(",")
      end
    elsif game == "any"
      current_roles = settings.active_roles.split(",")
      new_active_roles = settings.active_roles.split(",")
      current_roles.each do |current_role|
        if current_role.include?("-")
          role_split, game_split = current_role.split("-")
          if role_split.include?(role)
            new_active_roles.delete(role_split+"-"+game_split)
          end
        end
      end
      settings.active_roles = new_active_roles.join(",")
    else
      current_roles = settings.active_roles.split(",")
      if current_roles.include?(role+"-"+game)
        current_roles.delete(role+"-"+game)
        settings.active_roles = current_roles.join(",")
      end
    end
    settings.save
  end

  def self.only_member?(user)
    roles = user.roles
    roles.length() == 1
  end
end
