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
    let(:auth) { OmniAuth::AuthHash.new(provider: 'google_oauth2', info: { email: 'test@tamu.edu' }) }

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

  describe 'spotify' do
    let(:spotify_auth) do
      OmniAuth::AuthHash.new(
        provider: 'spotify',
        uid: '123456',
        credentials: { token: 'abcd' },
        info: { display_name: 'Test User' },
        extra: { raw_info: { id: 'spotify_username' } }
      )
    end

    before do
      request.env["omniauth.auth"] = spotify_auth
      allow_any_instance_of(SessionsController).to receive(:save_random_spotify_playlist)
    end

    context 'when user is valid' do
      let(:user) { double('Test User', id: 1, spotify_username: 'spotify_username', valid?: true) }

      it 'sets session[:user_id]' do
        allow(UserService).to receive(:spotify_user).with(spotify_auth).and_return(user)

        get :spotify

        expect(session[:user_id]).to eq(user.id)
      end

      it 'sets session[:spotify_access_token]' do
        allow(UserService).to receive(:spotify_user).with(spotify_auth).and_return(user)

        get :spotify

        expect(session[:spotify_access_token]).to eq(spotify_auth.credentials.token)
      end
    end

    context 'when user is invalid' do
      let(:user) { double('Test User', valid?: false) }

      it 'flashes login failed message' do
        allow(UserService).to receive(:spotify_user).with(spotify_auth).and_return(user)

        get :spotify

        expect(flash[:alert]).to eq("Login failed.")
      end
    end
  end

  describe 'github' do
    let(:github_auth) do
      OmniAuth::AuthHash.new(
        provider: 'github',
        uid: '123456',
        info: { nickname: 'testuser', name: 'Test User' },
        extra: { raw_info: { id: 'github_username' } }
      )
    end

    before do
      request.env["omniauth.auth"] = github_auth
    end

    context 'when user is valid' do
      let(:user) { double('Test User', id: 1, valid?: true) }

      it 'sets session[:user_id]' do
        allow(UserService).to receive(:github_user).with(github_auth).and_return(user)

        get :github

        expect(session[:user_id]).to eq(user.id)
      end
    end

    context 'when user is invalid' do
      let(:user) { double('Test User', valid?: false) }

      it 'flashes login failed message' do
        allow(UserService).to receive(:github_user).with(github_auth).and_return(user)

        get :github

        expect(flash[:alert]).to eq("Login failed.")
      end
    end
  end
end
