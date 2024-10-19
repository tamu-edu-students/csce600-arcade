# app/services/settings_service.rb
class SettingsService
  # SettingsService.user_has_active_role? user_id "System Admin" "Wordle"
  def self.user_has_active_role?(user_id, role_name, game_name = "")
    if not game_name.empty?
      game_id = Game.find_by(name: game_name).id
      role_id = Role.find_by(user_id: user_id, role: role_name, game_id: game_id).id
    else
      role_id = Role.find_by(user_id: user_id, role: role_name).id
    end
    Settings.find_by(user_id: user_id).roles.include? role_id
  end

  def self.get_active_roles(user_id)
    assigned_roles = Role.where(user_id: user_id)
    active_role_ids = Settings.find_by(user_id: user_id).roles
    assigned_roles.select { |r| active_role_ids.include? r.id }
  end

  def self.only_active_as_member?(user_id)
    Settings.find_by(user_id: user_id).roles.select { |r| Role.find_by(id: r).role != "Member" }.empty?
  end
end
