# spec/controllers/settings_controller_spec.rb
require 'rails_helper'

RSpec.describe SettingsController, type: :controller do
  before do
    User.destroy_all
    Settings.destroy_all
  end
  let(:user) do
    User.create(first_name: 'Test', last_name: 'User', email: 'test@example.com', uid: '1')
  end
  let(:settings) do
    Settings.create(roles: [], user_id: user.id)
  end
  before do
    session[:user_id] = user.id
  end

  describe 'update' do
    it 'sets active roles appropriately' do
      post :update, params: { id: settings.id, roles: [ "Puzzle Setter" ] }
      expect(settings.reload.roles).to eq([ "Puzzle Setter" ])
    end
  end
end
