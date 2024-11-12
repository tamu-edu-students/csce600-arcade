# spec/controllers/wordles_controller_spec.rb
require 'rails_helper'

RSpec.describe WordlesController, type: :controller do
    before do
        User.destroy_all
        Wordle.destroy_all

        WordleValidSolution.create!(word: 'floop')
        WordleValidSolution.create!(word: 'ploof')
      end

  let(:puzzle_setter) { User.create(first_name: 'Test', last_name: 'User', email: 'test@example.com') }
  let(:member) { User.create(first_name: 'Test2', last_name: 'User', email: 'test2@example.com') }

  before do
    Role.find_or_create_by!(user_id: member.id, role: "Member")
    session[:user_id] = member.id
  end

  describe 'GET #index' do
    it 'redirects to play path if no Puzzle Setters are enabled' do
      get :index
      expect(response).to redirect_to(welcome_path)
    end

    it 'redirects to play path if user is not a Puzzle Setter' do
      Role.find_or_create_by!(user_id: puzzle_setter.id, role: "Puzzle Setter")
      get :index
      expect(response).to redirect_to(wordles_play_path)
    end
  end

  describe 'DELETE #destroy' do
    before do
      allow(controller).to receive(:check_session_id)
    end
    it 'actually does the delete' do
      wordle = Wordle.create(play_date: Date.today+1000, word: 'floop')
      delete :destroy, params: { id: wordle.id }
      expect(Wordle.find_by(id: wordle.id)).to be_nil
    end
  end

  describe 'PATCH/PUT #update' do
    before do
      allow(controller).to receive(:check_session_id)
    end
    it 'actually does the update' do
      wordle = Wordle.create(play_date: Date.today+1000, word: 'floop')
      patch :update, params: { id: wordle.id, wordle: { word: 'ploof' } }
      wordle.reload
      expect(wordle.word).to eq('ploof')
    end

    it 'does no update when nil' do
      wordle = Wordle.create(play_date: Date.today+1000, word: 'floop')
      patch :update, params: { id: wordle.id, wordle: { word: nil } }
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST #create' do
    before do
      allow(controller).to receive(:check_session_id)
    end
    it 'actually does the create' do
      expect(Wordle.find_by(word: "ploof")).to be_nil
      post :create, params: {
        wordle: {
          play_date: Date.today,
          word: "ploof"
        }
      }
      expect(Wordle.find_by(word: "ploof")).not_to be_nil
    end

    it 'does no create when nil' do
      expect(Wordle.find_by(word: "ploof")).to be_nil
      post :create, params: {
        wordle: {
          play_date: Date.today,
          word: nil
        }
      }
      expect(response).to render_template(:new)
    end
  end

  describe 'guest' do
    it 'does not allow guest to view index' do
      session[:guest] = true
      get :index
      expect(response).to redirect_to(wordles_play_path)
    end
  end

  describe 'GET #play' do
    before do
      allow(WordsService).to receive(:define).and_return('definition')
      game = Game.find_or_create_by(name: 'Wordle')
      Aesthetic.find_or_create_by(game_id: game.id)
      @wordle = Wordle.create(play_date: Date.today, word: 'floop')
    end
    it 'plays' do
      get :play, params: { id: @wordle.id }
      expect(assigns(:definition)).to eq('definition')
    end

    it 'plays with reset' do
      session[:wordle_attempts] = 5
      get :play, params: { id: @wordle.id, reset: true }
      expect(session[:wordle_attempts]).to eq(0)
    end

    it 'plays with a correct guess' do
      allow_any_instance_of(WordlesHelper).to receive(:validate_guess).and_return(false)
      get :play, params: { id: @wordle.id, guess: 'not floop' }
      expect(session[:wordle_attempts]).to eq(0)
    end

    it 'updates correctly' do
      allow_any_instance_of(WordlesHelper).to receive(:validate_guess).and_return(true)
      get :play, params: { id: @wordle.id, guess: 'ploof' }
      expect(session[:wordle_attempts]).to eq(1)
    end
  end

  describe 'wordle always exists' do
    before do
      allow(WordsService).to receive(:define).and_return('definition')
      game = Game.find_or_create_by(name: 'Wordle')
      Aesthetic.find_or_create_by(game_id: game.id)
    end
    it 'play with no params' do
      get :play
      expect(assigns(:wordle).word).to satisfy { |word| [ 'floop', 'ploof' ].include?(word) }
    end
  end

  describe 'GET #index' do
    before do
      game = Game.create(name: 'Wordle')
      Role.create!(user_id: puzzle_setter.id, role: "Puzzle Setter", game_id: game.id)
      Wordle.create(play_date: Date.today, word: 'floop')
      Wordle.create(play_date: Date.today + 1, word: 'ploof')
    end

    it 'indexes' do
      session[:user_id] = puzzle_setter.id
      get :index
      expect(assigns(:wordles).length).to eq(2)
    end
  end

  describe 'GET #new' do
    before do
      game = Game.create(name: 'Wordle')
      Role.create!(user_id: puzzle_setter.id, role: "Puzzle Setter", game_id: game.id)
    end

    it 'creates new @wordle' do
      session[:user_id] = puzzle_setter.id
      get :new
      expect(assigns(:wordle)).to be_a_new(Wordle)
    end
  end
end
