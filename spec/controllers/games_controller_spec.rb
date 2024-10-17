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

  describe "new" do
    it "assigns to @game" do
      get :new
      expect(assigns(:game)).to be_a_new(Game)
    end
  end

  describe "destroy" do
    let!(:game_to_destroy) { Game.create(name: 'Destroy Game', game_path: 'path_to_destroy') }

    it "destroys the requested game" do
      expect {
        delete :destroy, params: { id: game_to_destroy.id }
      }.to change(Game, :count).by(-1)
    end

    it "redirects" do
      delete :destroy, params: { id: game.id }
      expect(response).to redirect_to(games_path)
    end

    it "destroy notice" do
      delete :destroy, params: { id: game.id }
      expect(flash[:notice]).to eq("Game was successfully destroyed.")
    end
  end

  describe "update" do
    context "with valid params" do
      let(:new_attributes) { { name: 'Updated Game' } }

      it "updates" do
        patch :update, params: { id: game.id, game: new_attributes }
        game.reload
        expect(game.name).to eq('Updated Game')
      end

      it "redirects" do
        patch :update, params: { id: game.id, game: new_attributes }
        expect(response).to redirect_to(game)
      end

      it "update notice" do
        patch :update, params: { id: game.id, game: new_attributes }
        expect(flash[:notice]).to eq("Game was successfully updated.")
      end
    end

    context "with invalid params" do
      it "renders" do
        patch :update, params: { id: game.id, game: { name: '' } }
        expect(response).to render_template(:edit)
      end

      it "fails" do
        patch :update, params: { id: game.id, game: { name: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "create" do
    context "with valid params" do
      let(:valid_attributes) { { name: 'New Game', game_path: 'new_game_path' } }

      it "creates a new game" do
        expect {
          post :create, params: { game: valid_attributes }
        }.to change(Game, :count).by(1)
      end

      it "redirects" do
        post :create, params: { game: valid_attributes }
        expect(response).to redirect_to(Game.last)
      end

      it "create notice" do
        post :create, params: { game: valid_attributes }
        expect(flash[:notice]).to eq("Game was successfully created.")
      end
    end

    context "with invalid params" do
      let(:invalid_attributes) { { name: '', game_path: '' } }

      it "does not create a new game" do
        expect {
          post :create, params: { game: invalid_attributes }
        }.to change(Game, :count).by(0)
      end

      it "renders" do
        post :create, params: { game: invalid_attributes }
        expect(response).to render_template(:new)
      end

      it "fails" do
        post :create, params: { game: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
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

  describe "#dictionary_check" do
    let(:valid_word) { 'foot' }
    let(:invalid_word) { 'xyzzy' }

    it "returns true for a valid word in the dictionary" do
      allow(HTTP).to receive(:get).and_return(
          double(status: double(success?: true), parse: [ {} ])
      )
      expect(controller.send(:dictionary_check, valid_word)).to be true
    end

    it "returns false for an invalid word not in the dictionary" do
      allow(HTTP).to receive(:get).and_return(
          double(status: double(success?: true), parse: [])
      )
      expect(controller.send(:dictionary_check, invalid_word)).to be false
    end

    it "handles API request failures gracefully" do
      allow(HTTP).to receive(:get).and_raise(StandardError)
      expect(controller.send(:dictionary_check, valid_word)).to be false
    end
  end

  describe "#valid_word?" do
    let(:valid_letters) { %w[A B C D O F] }
    let(:center_letter) { 'T' }

    before do
      session[:sbwords] = []
    end

    it "returns true for a valid word" do
      allow(controller).to receive(:dictionary_check).and_return(true)
      expect(controller.send(:valid_word?, 'BATT', valid_letters, center_letter)).to be true
    end

    it "returns false if the word does not include the center letter" do
      expect(controller.send(:valid_word?, 'FOOD', valid_letters, center_letter)).to be false
      expect(assigns(:error_message)).to eq("The word must include the center letter 'T'.")
    end

    it "returns false if the word contains invalid letters" do
      expect(controller.send(:valid_word?, 'CAXT', valid_letters, center_letter)).to be false
      expect(assigns(:error_message)).to eq("The word must be composed of the letters: A, B, C, D, O, F.")
    end

    it "returns false if the word is less than 4 letters" do
      expect(controller.send(:valid_word?, 'BAT', valid_letters, center_letter)).to be false
      expect(assigns(:error_message)).to eq("The word must be at least 4 letters long.")
    end

    it "returns false if the word has already been used" do
      session[:sbwords] << 'BATT'
      expect(controller.send(:valid_word?, 'BATT', valid_letters, center_letter)).to be false
      expect(assigns(:error_message)).to eq("You have already used the word 'BATT'.")
    end

    it "returns false if the word is not in the dictionary" do
      allow(controller).to receive(:dictionary_check).and_return(false)
      expect(controller.send(:valid_word?, 'BATT', valid_letters, center_letter)).to be false
      expect(assigns(:error_message)).to eq("The word 'BATT' is not in the dictionary.")
    end
  end

  describe "POST #spellingbee" do
    let(:valid_word) { 'BATT' }
    let(:invalid_word) { 'CAXT' }

    before do
      session[:sbscore] = 0
      session[:sbwords] = []
      allow(Aesthetic).to receive(:find_by).and_return(double('Aesthetic', game_id: 1))
      allow(controller).to receive(:dictionary_check).and_return(true) 
    end

    context "when submitting a valid word" do
      before do
        allow(controller).to receive(:dictionary_check).and_return(true)
        post :spellingbee, params: { id: 1, sbword: valid_word }
      end

      it "adds the word to the session" do
        expect(session[:sbwords]).to include(valid_word.upcase)
      end

      it "updates the score" do
        expect(session[:sbscore]).to eq(40)
      end

      it "renders the spellingbee template" do
        expect(response).to render_template("spellingbee")
      end
    end

    context 'when submitting an invalid word' do
      let(:invalid_word) { 'FOOT' }

      before do
        allow(controller).to receive(:dictionary_check).and_return(false)
        post :spellingbee, params: { id: 1, sbword: invalid_word }
      end

      it 'does not add the word to session[:sbwords]' do
        expect(session[:sbwords]).not_to include(invalid_word.upcase)
      end

      it 'does not update the score' do
        expect(session[:sbscore]).to eq(0)
      end

      it 'renders the spellingbee template with an error message' do
        expect(response).to render_template("spellingbee")
        expect(assigns(:error_message)).to eq("The word '#{invalid_word}' is not in the dictionary.")
      end
    end
  end
end
