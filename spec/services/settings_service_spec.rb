# spec/controllers/settings_controller_spec.rb
require 'rails_helper'

RSpec.describe SettingsService, type: :service do
  before do
    User.destroy_all
    Role.destroy_all
    Settings.destroy_all
  end

  let(:user) do
    User.create!(first_name: 'Test', last_name: 'User', email: 'test@example.com')
  end

  describe 'role_exists?' do
    it 'identifies non-game role' do
      settings = Settings.find_or_create_by!(active_roles: "System Admin", user_id: user.id)
      expect(SettingsService.role_exists? user, "System Admin").to be true
      settings.destroy!
    end

    it 'identifies game role' do
      game = Game.create!(name: "Wordle")
      settings = Settings.find_or_create_by!(active_roles: "Puzzle Aesthetician-Wordle", user_id: user.id)
      expect(SettingsService.role_exists? user, "Puzzle Aesthetician", game).to be true
      settings.destroy!
      game.destroy!
    end

    it 'identifies game role no match' do
      game = Game.create!(name: "Wordle")
      settings = Settings.find_or_create_by!(active_roles: "Puzzle Aesthetician-Spelling Bee", user_id: user.id)
      expect(SettingsService.role_exists? user, "Puzzle Aesthetician", game).to be false
      settings.destroy!
      game.destroy!
    end
  end

  describe 'remove_role' do
    it 'deletes basic' do
      settings = Settings.find_or_create_by!(active_roles: "System Admin", user_id: user.id)
      SettingsService.remove_role user, "System Admin"
      expect(settings.reload.active_roles).to eq("")
      settings.destroy!
    end

    it 'deletes any game role' do
      settings = Settings.find_or_create_by!(active_roles: "Puzzle Aesthetician-Wordle,Puzzle Aesthetician-Spelling Bee", user_id: user.id)
      SettingsService.remove_role user, "Puzzle Aesthetician", "any"
      expect(settings.reload.active_roles).to eq("")
      settings.destroy!
    end

    it 'deletes specific game role' do
      settings = Settings.find_or_create_by!(active_roles: "Puzzle Aesthetician-Wordle,Puzzle Aesthetician-Spelling Bee", user_id: user.id)
      SettingsService.remove_role user, "Puzzle Aesthetician", "Wordle"
      expect(settings.reload.active_roles).to eq("Puzzle Aesthetician-Spelling Bee")
      settings.destroy!
    end
  end

  describe 'only_member?' do
    it 'identifies only member' do
      role = Role.find_or_create_by!(user_id: user.id, role: "Member")
      expect(SettingsService.only_member? user).to be true
      role.destroy!
    end
  end
end
