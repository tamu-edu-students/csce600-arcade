# spec/controllers/users_controller_spec.rb
require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before do
    User.destroy_all
  end
  let(:user) do User.create(first_name: 'Test', last_name: 'User', email: 'test@example.com', uid: '1')
  end
  before do
    session[:user_id] = user.id
  end

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
    it 'assigns the current user' do
      get :show, params: { id: user.id }
      expect(assigns(:current_user)).to eq(user)
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
