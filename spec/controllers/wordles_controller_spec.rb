require 'rails_helper'

RSpec.describe WordlesController, type: :controller do
  before do
    User.destroy_all
    Wordle.destroy_all

    # Seed wordles for the tests
    Wordle.create(play_date: Date.today, word: 'apple')
    Wordle.create(play_date: Date.today + 1, word: 'baked')
    Wordle.create(play_date: Date.today + 2, word: 'cared')
  end

  let(:puzzle_setter) { User.create(first_name: 'Test', last_name: 'User', email: 'test@example.com') }
  let(:guest_user) { { guest: true } }

  before do
    Role.find_or_create_by!(user_id: puzzle_setter.id, role: "Puzzle Setter")
  end

  describe 'GET #index' do
    context 'when there are no Puzzle Setters enabled' do
      it 'redirects with an error to the welcome page' do
        get :index
        expect(response).to redirect_to(welcome_path)
      end
    end

    context 'when the user is not a Puzzle Setter' do
      before do
        session[:user_id] = puzzle_setter.id
        Role.destroy_all # Ensure no puzzle setters exist
      end

      it 'redirects with an error to the welcome page' do
        get :index
        expect(response).to redirect_to(welcome_path)
      end
    end
  end

  describe 'GET #play as guest' do
    before do
      session[:guest] = true
    end

    it 'allows guests to play' do
      get :play
      expect(response).to have_http_status(:success)
    end

    it 'does not allow guests to access the index action' do
        session[:guest] = true
        get :index
        expect(response).to redirect_to(wordles_play_path)
      end      
  end

  describe 'GET #new' do
    context 'when the user is a Puzzle Setter' do
      before do
        session[:user_id] = puzzle_setter.id
      end

      it 'assigns a new Wordle' do
        get :new
        expect(assigns(:wordle)).to be_a_new(Wordle)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the Wordle' do
      session[:user_id] = puzzle_setter.id
      wordle = Wordle.create(play_date: Date.today + 1000, word: 'floop')
      delete :destroy, params: { id: wordle.id }
      expect(Wordle.find_by(id: wordle.id)).to be_nil
    end
  end

  describe 'PATCH/PUT #update' do
    it 'updates the Wordle' do
      session[:user_id] = puzzle_setter.id
      wordle = Wordle.create(play_date: Date.today + 1000, word: 'floop')
      patch :update, params: { id: wordle.id, wordle: { word: 'ploof' } }
      wordle.reload
      expect(wordle.word).to eq('ploof')
    end
  end

  describe 'POST #create' do
    it 'creates a new Wordle' do
      session[:user_id] = puzzle_setter.id
      expect {
        post :create, params: { wordle: { play_date: Date.today, word: 'ploof' } }
      }.to change(Wordle, :count).by(1)
    end
  end
end
