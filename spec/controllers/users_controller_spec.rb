# spec/controllers/users_controller_spec.rb
require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before do
    User.destroy_all
  end
  let(:user) do User.create(first_name: 'Test', last_name: 'User', email: 'test@example.com')
  end
  before do
    session[:user_id] = user.id
  end

  describe 'index' do
    let(:users) { [ double('Test User1'), double('Test User2') ] }

    it 'all users access blocked when user not a Sys Admin' do
      get :index
      expect(response).to redirect_to("#")
    end

    it 'all users access blocked when user_id missing' do
      get :index
      expect(flash[:alert]).to include('You are not authorized to access this page.')
    end
    # it 'all users fetches all users' do
    #   Role.find_or_create_by!(user_id: user.id, role: "System Admin")
    #   get :index
    #   expect(assigns(:users)).to eq(users)
    # end
  end

  describe 'show' do
    it 'assigns the current user' do
      get :show, params: { id: user.id }
      expect(assigns(:current_user)).to eq(user)
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

  describe 'update' do
    let(:valid_params) { { user: { email: 'updated_test@example.com' } } }

    it 'updates user email' do
      patch :update, params: { id: user.id, user: valid_params[:user] }
      user.reload
      expect(user.email).to eq('updated_test@example.com')
    end
  end

  describe 'delete' do
    let!(:user) { User.create(email: 'test@example.com', first_name: 'Test', last_name: 'User') } # Ensure user is created

    it 'deletes the user' do
      delete :destroy, params: { id: user.id }
      expect(User.find_by(id: user.id)).to be_nil
    end
  end

  describe 'checks if im sys admin' do
    it 'checks sys admin map' do
      User.create(id: 2)
      User.create(id: 3)
      Role.create(user_id: 2, role: "System Admin")
      Role.create(user_id: 3, role: "Member")
      Role.create(user_id: 3, role: "Member")
      session[:user_id] = 3
      get :index
      expect(flash[:alert]).to include(/You are not authorized to access this page./)
    end
  end
end
