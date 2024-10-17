require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  before do
    User.destroy_all
  end

  let!(:user) { User.create(email: 'test@tamu.edu', first_name: 'Test', last_name: 'User') }
  let!(:game) { Game.create(name: 'Test Game', game_path: 'test_game_path') }

  before do
    session[:user_id] = user.id
  end

  describe "index" do
    it "works" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "assigns @games" do
      get :index
      expect(assigns(:games)).to include(game)
    end

    it "assigns @current_user" do
      get :index
      expect(assigns(:current_user)).to eq(user)
    end
  end

  describe "demo game" do
    let!(:demo_game) { Game.create(name: 'Demo Game', game_path: 'demo_game_path') }

    it "assigns to @games" do
      get :demo_game, params: { id: demo_game.id }
      expect(assigns(:game)).to eq(demo_game)
    end

    it "renders" do
      get :demo_game, params: { id: demo_game.id }
      expect(response).to render_template(:demo_game)
    end

    it "handles game not found" do
      expect {
        get :demo_game, params: { id: 'invalid' }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "GET #show" do
    let!(:invalid_game) { Game.create(name: 'Invalid Game', game_path: 'invalid_game_path') }

    before do
        allow(controller).to receive(:redirect_to)
    end

    it "raises a NoMethodError since route does not exist" do
        expect {
        get :show, params: { id: invalid_game.id }
        }.to raise_error(NoMethodError)
    end
  end

  describe "spellingbee" do
    before do
      session[:sbscore] = 0
      session[:sbwords] = []
    end

    let(:valid_letters) { ['A', 'B', 'C', 'D', 'O', 'F'] }
    let(:center_letter) { 'T' }
    let(:game_id) { 1 }
    let(:aesthetic) { double('Aesthetic', game_id: game_id) }

    before do
      allow(Aesthetic).to receive(:find_by).and_return(aesthetic)
    end

    context 'when submitting a valid 4-letter word' do
      let(:submitted_word) { 'BATT' }

      before do
        post :spellingbee, params: { id: game_id, sbword: submitted_word }
      end

      it 'adds the word to session[:sbwords]' do
        expect(session[:sbwords]).to include(submitted_word.upcase)
      end

      it 'updates the score' do
        expect(session[:sbscore]).to eq(40)
      end

      it 'renders the spellingbee template' do
        expect(response).to render_template("spellingbee")
      end
    end

    context 'when submitting an invalid 4-letter word' do
      let(:invalid_word) { 'CAZT' }

      before do
        post :spellingbee, params: { id: game_id, sbword: invalid_word }
      end

      it 'does not add the word to session[:sbwords]' do
        expect(session[:sbwords]).not_to include(invalid_word.upcase)
      end

      it 'does not update the score' do
        expect(session[:sbscore]).to eq(0)
      end
    end
  end
end
