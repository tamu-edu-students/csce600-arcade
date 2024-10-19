# spec/controllers/settings_controller_spec.rb
require 'rails_helper'

RSpec.describe RolesController, type: :controller do
  before do
    User.destroy_all
    Role.destroy_all
    Settings.destroy_all
  end

  describe 'update_roles' do
    it 'sets roles appropriately' do
      user = User.find_or_create_by!(first_name: 'Test', last_name: 'User', email: 'test@example.com')
      session[:user_id] = user.id
      role = Role.find_or_create_by!(user_id: user.id, role: "System Admin")
      settings = Settings.find_or_create_by!(user_id: user.id, roles: [ role.id ])

      patch :update_roles, params: { user_roles: { user.id => [ "System Admin", "Member" ] } }
      expect(response).to redirect_to(users_path)
      expect(Role.where(user_id: user.id).length).to eq(2)
      settings.destroy!
      role.destroy!
      user.destroy!
    end
  end
end
