# spec/controllers/welcome_controller_spec.rb
require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  describe 'GET #index' do
    context 'when a user' do
      before do
        allow(controller).to receive(:logged_in?).and_return(true)
        get :index
      end

      it 'redirects to games_path' do
        expect(response).to redirect_to(games_path)
      end
    end

    context 'when a guest' do
      before do
        session[:guest] = true
        get :index
      end

      it 'redirects to games_path' do
        expect(response).to redirect_to(games_path)
      end
    end

    context 'when not user or guest' do
      before do
        allow(controller).to receive(:logged_in?).and_return(false)
        get :index
      end

      it 'renders the index template' do
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'guest' do
    it 'session[:guest]' do
      post :guest

      expect(session[:guest]).to eq(true)
    end
  end
end
