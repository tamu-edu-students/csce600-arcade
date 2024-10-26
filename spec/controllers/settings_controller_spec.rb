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

  describe 'update_settings defaults' do
    it 'has default page contrast for user settings' do
      expect(settings.page_contrast).to eq(100)
    end

    it 'has default game font casing for user settings' do
      expect(settings.game_font_casing).to eq(true)
    end
  end

  describe 'update_settings' do
    it 'updates page contrast for user settings' do
      post :update_settings, params: { id: settings.id, settings: { page_contrast: 400 } }
      expect(settings.reload.page_contrast).to eq(400)
    end

    it 'updates game font casing for user settings' do
      post :update_settings, params: { id: settings.id, settings: { game_font_casing: false } }
      expect(settings.reload.game_font_casing).to eq(false)
    end

    it 'fails if the user is a guest' do
      session[:guest] = true
      post :update_settings, params: { id: settings.id, settings: { game_font_casing: false } }
      expect(response).to have_http_status(401)
    end

    it 'sets active roles appropriately' do
      post :update_settings, params: { id: settings.id, settings: { active_roles: [ "System Admin" ] } }
      expect(settings.reload.active_roles).to eq("System Admin")
    end
  end
end
