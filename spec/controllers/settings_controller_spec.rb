# spec/controllers/settings_controller_spec.rb
require 'rails_helper'

RSpec.describe SettingsController, type: :controller do
  before do
    User.destroy_all
    Role.destroy_all
    Settings.destroy_all
  end
  let(:user) do
    User.create(first_name: 'Test', last_name: 'User', email: 'test@example.com')
  end
  let(:settings) do
    Settings.create(active_roles: "", user_id: user.id)
  end
  before do
    session[:user_id] = user.id
  end

  describe 'update' do
    it 'sets active roles appropriately' do
      post :update, params: { id: settings.id, settings: { active_roles: [ "System Admin" ] } }
      expect(settings.reload.active_roles).to eq("System Admin")
    end

    it 'handles just member appropriately' do
      post :update, params: { id: settings.id, settings: { active_roles: [ "System Admin" ] } }
      post :update, params: { id: settings.id }
      expect(settings.reload.active_roles).to eq("")
    end
  end
end
