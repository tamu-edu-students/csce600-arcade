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

  describe 'has_active_role?' do
    it 'identifies if role is active' do
      role = Role.find_or_create_by!(user_id: user.id, role: "System Admin")
      settings = Settings.find_or_create_by!(roles: [ role.id ], user_id: user.id)
      expect(SettingsService.user_has_active_role? user.id, "System Admin").to be true
      role.destroy!
      settings.destroy!
    end
  end

  describe 'get_active_roles' do
    it 'returns correct active roles' do
      role = Role.find_or_create_by!(user_id: user.id, role: "System Admin")
      settings = Settings.find_or_create_by!(roles: [ role.id ], user_id: user.id)
      expect(SettingsService.get_active_roles user.id).to eq([ role ])
      role.destroy!
      settings.destroy!
    end
  end

  describe 'only_active_as_member?' do
    it 'identifies only member' do
      role = Role.find_or_create_by!(user_id: user.id, role: "Member")
      settings = Settings.find_or_create_by!(roles: [ role.id ], user_id: user.id)
      expect(SettingsService.only_active_as_member? user.id).to be true
      role.destroy!
      settings.destroy!
    end
  end
end
