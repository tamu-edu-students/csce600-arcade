# app/services/settings_service.rb
class SettingsService
  def self.role_exists?(user, role, game = "")
    settings = Settings.find_by(user_id: user.id)
    return false unless settings&.active_roles.present?
  
    role_regex = if game.present?
                   /\A#{Regexp.escape(role)}-#{Regexp.escape(game.name)}\z/
                 else
                   /\A#{Regexp.escape(role)}\z/
                 end
  
    settings.active_roles.split(",").map(&:strip).any? do |active_role|
      active_role.match?(role_regex)
    end
  end
  

  def self.remove_role(user, role, game = "")
    settings = Settings.find_by(user_id: user.id)
    return unless settings&.active_roles.present?
  
    current_roles = settings.active_roles.split(",").map(&:strip)
  
    if !game.present?
      settings.active_roles = current_roles.reject { |r| r == role }.join(",")
    elsif game == "any"
      role_regex = /\A#{Regexp.escape(role)}-/
      settings.active_roles = current_roles.reject { |r| r.match?(role_regex) }.join(",")
    else
      role_game_pair = "#{role}-#{game}"
      settings.active_roles = current_roles.reject { |r| r == role_game_pair }.join(",")
    end
  
    settings.save
  end

  def self.only_member?(user)
    roles = user.roles
    roles.length() == 1
  end
end
