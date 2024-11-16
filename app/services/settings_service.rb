# app/services/settings_service.rb
class SettingsService
  # This method checks if a user has a particular active role
  # @param [Integer] user the id of the user
  # @param [String] role the role being checked
  # @param [String] game the game tied to the role (if any)
  # @return [Boolean] whether the user has the active role
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

  # This method removes a role from the users active roles
  # @param [Integer] user the id of the user
  # @param [String] role the role being checked
  # @param [String] game the game tied to the role (if any)
  # @return [nil]
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

  # This method checks if the user has no active roles other than member
  # @return [Boolean] whether the user has no other active roles
  def self.only_member?(user)
    roles = user.roles
    roles.length() == 1
  end
end
