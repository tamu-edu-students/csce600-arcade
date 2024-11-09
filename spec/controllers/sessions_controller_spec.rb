# spec/controllers/sessions_controller_spec.rb
require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  before do
    User.destroy_all
  end

  describe 'logout' do
    before do
      allow(controller).to receive(:require_login)
    end

    it 'flashes logout message' do
      session[:user_id] = 1
      post :logout

      expect(flash[:notice]).to eq("You are logged out.")
    end
  end
end
