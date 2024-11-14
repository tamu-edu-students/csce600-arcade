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

  describe '#omniauth' do
  before do
    @oauth_service = double('OauthService')
    allow(OauthService).to receive(:new).and_return(@oauth_service)
  end

  it 'redirects on failure to welcome' do
    allow(@oauth_service).to receive(:connect_user).and_return({ success: false })
    get :omniauth
    expect(response).to redirect_to(welcome_path)
  end

  it 'logs in on success' do
    user = double('User', id: 1)
    result = { success: true, user: user }
    allow(@oauth_service).to receive(:connect_user).and_return(result)
    get :omniauth
    expect(session[:user_id]).to eq(user.id)
  end
end
end
