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

    context 'linking google' do
      before do
        session[:user_id] = 1
        @user = User.create(id: 1, spotify_username: 'spotify1')
      end

      it 'works' do
        get :omniauth
        expect(flash[:notice]).to eq('Connected Google account.')
      end

      it 'fails already exists' do
        @user1 = User.create(id: 2, spotify_username: 'spotify2', email: 'test@tamu.edu')
        get :omniauth
        expect(flash[:alert]).to eq('Account already exists with those credentials.')
      end
    end
  end

  describe 'spotify' do
    let(:spotify_auth) do
      OmniAuth::AuthHash.new(
        provider: 'spotify',
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

    context 'linking spotify' do
      before do
        session[:user_id] = 1
        @user = User.create(id: 1, email: 'test@tamu.edu')
      end

      it 'works' do
        get :spotify
        expect(flash[:notice]).to eq('Connected Spotify account.')
      end

      it 'fails already exists' do
        @user1 = User.create(id: 2, email: 'test2@tamu.edu', spotify_username: 'spotify_username')
        get :spotify
        expect(flash[:alert]).to eq('Account already exists with those credentials.')
      end
    end
  end

  describe 'github' do
    let(:github_auth) do
      OmniAuth::AuthHash.new(
        provider: 'github',
        info: { nickname: 'testuser', name: 'Test User' }
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

    context 'linking github' do
      before do
        session[:user_id] = 1
        @user = User.create(id: 1, email: 'test@tamu.edu')
      end

      it 'works' do
        get :github
        expect(flash[:notice]).to eq('Connected Github account.')
      end

      it 'fails already exists' do
        @user1 = User.create(id: 2, email: 'test2@tamu.edu', github_username: 'testuser')
        get :github
        expect(flash[:alert]).to eq('Account already exists with those credentials.')
      end
    end
  end

  describe 'vibelist' do
    let(:access_token) { 'test_access_token' }
    let(:spotify_username) { 'test_username' }

    before do
      session[:user_id] = 1
    end

    it 'yes ur list' do
      playlists = [ { "id" => "playlist_1" }, { "id" => "playlist_2" } ]
      response = double('response', body: { "items" => playlists }.to_json)
      http_double = double('http')
      allow(Net::HTTP).to receive(:new).and_return(http_double)
      allow(http_double).to receive(:use_ssl=).with(true)
      allow(http_double).to receive(:request).and_return(response)
      controller.send(:save_random_spotify_playlist, access_token, spotify_username)
      expect(session[:spotify_playlist]).to be_present
      expect(playlists.map { |p| p["id"] }).to include(session[:spotify_playlist])
    end

    it 'nope my music' do
      response = double('response', body: { "items" => [] }.to_json)
      http_double = double('http')
      allow(Net::HTTP).to receive(:new).and_return(http_double)
      allow(http_double).to receive(:use_ssl=).with(true)
      allow(http_double).to receive(:request).and_return(response)
      controller.send(:save_random_spotify_playlist, access_token, spotify_username)
      expect(session[:spotify_playlist]).to be_nil
    end
  end
end
