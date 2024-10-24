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
  end

  describe "GET #show" do
  let!(:game) { Game.create(name: 'Test Game', game_path: 'non_existent_path') }

  it "redirects to games path with an alert when the game_path does not exist" do
    allow(controller).to receive(:redirect_to).and_call_original # Allow normal redirect behavior

    get :show, params: { id: game.id }

    expect(response).to redirect_to(games_path)
    expect(flash[:alert]).to eq("Game path not found.")
  end
end
end
