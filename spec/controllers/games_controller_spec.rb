require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  before do
    User.destroy_all
  end

  let!(:user) { User.create(uid: '1', email: 'test@tamu.edu', first_name: 'Test', last_name: 'User') }
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
end
