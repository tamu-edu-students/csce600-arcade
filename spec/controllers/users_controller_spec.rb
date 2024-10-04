# spec/controllers/users_controller_spec.rb
require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'index' do
    let(:users) { [ double('Test User1'), double('Test User2') ] }

    before do
      allow(controller).to receive(:logged_in?).and_return(true)
      allow(UserService).to receive(:fetch_all).and_return(users)
    end

    it 'fetches all users' do
      get :index
      expect(assigns(:users)).to eq(users)
    end
  end

  describe 'show' do
    let(:user) { double('User') }

    before do
      allow(controller).to receive(:logged_in?).and_return(true)
      allow(UserService).to receive(:find_user_by_id).with('1').and_return(user)
    end

    it 'finds the user' do
      get :show, params: { id: '1' }
      expect(assigns(:current_user)).to eq(user)
    end
  end

  describe 'edit' do
    let(:user) { double('User') }

    before do
      allow(controller).to receive(:current_user).and_return(user)
      allow(UserService).to receive(:find_user_by_id).with('1').and_return(user)
    end

    it 'renders edit' do
      get :edit, params: { id: 1 }
      expect(response).to render_template(:edit)
    end
  end

  describe 'destroy' do
    let(:user) { double('User', id: 1, destroy!: true) }

    before do
      allow(controller).to receive(:current_user).and_return(user)
      allow(UserService).to receive(:find_user_by_id).with('1').and_return(user)
    end

    it 'destroys the user' do
      delete :destroy, params: { id: user.id }

      expect(user).to have_received(:destroy!)
      expect(flash[:notice]).to eq("Account successfully deleted")
    end
  end

  describe 'when not logged in' do
    before do
      allow(controller).to receive(:logged_in?).and_return(false)
    end

    it 'redirects to welcome path with alert' do
      get :index
      expect(response).to redirect_to(welcome_path)
      expect(flash[:alert]).to eq("You must be logged in or a guest to access this section.")
    end
  end
end
