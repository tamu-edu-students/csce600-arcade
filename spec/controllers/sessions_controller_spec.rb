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

  describe 'omniauth' do
    let(:auth) { OmniAuth::AuthHash.new(provider: 'google_oauth2', uid: '1', info: { email: 'test@tamu.edu' }) }

    before do
      request.env["omniauth.auth"] = auth
    end

    context 'when user is valid' do
      let(:user) { double('Test User', id: 1, valid?: true) }

      it 'sets session[:user_id]' do
        allow(UserService).to receive(:find_or_create_user).with(auth).and_return(user)

        get :omniauth

        expect(session[:user_id]).to eq(user.id)
      end
    end

    context 'when user is invalid' do
      let(:user) { double('Test User', valid?: false) }

      it 'flashes login failed message' do
        allow(UserService).to receive(:find_or_create_user).with(auth).and_return(user)

        get :omniauth

        expect(flash[:alert]).to eq("Login failed.")
      end
    end
  end
end
