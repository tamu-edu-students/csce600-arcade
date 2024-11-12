require 'rails_helper'

RSpec.describe Game2048Controller, type: :controller do
  before do
    Game.destroy_all
    Game.create(id: -1, name: 'Dummy Game', game_path: 'dummy_play_path')
    @game = Game.create(name: '2048', game_path: 'game_2048_play_path')
    @aesthetic = Aesthetic.create(
      game_id: @game.id,
      colors: [ '#CDC1B4', '#EEE4DA', '#EDE0C8' ],
      labels: [ 'background', 'tile-2', 'tile-4' ],
      font: 'Clear Sans'
    )
    @user = User.create(email: 'test@example.com', first_name: 'Test', last_name: 'User')
    session[:user_id] = @user.id
  end

  describe "GET #play" do
    it "renders the game board" do
      get :play, params: { use_route: :game_2048_play }
      expect(response).to have_http_status(:success)
      expect(assigns(:aesthetic)).to eq(@aesthetic)
    end

    it "initializes the game if not started" do
      get :play, params: { use_route: :game_2048_play }
      expect(session[:game_2048_board]).not_to be_nil
      expect(session[:game_2048_score]).to eq(0)
      expect(session[:game_2048_over]).to be false
      expect(session[:game_2048_won]).to be false
    end
  end

  describe "POST #make_move" do
    before do
      session[:game_2048_board] = Array.new(4) { Array.new(4, 0) }
      session[:game_2048_score] = 0
      session[:game_2048_over] = false
      session[:game_2048_won] = false
    end

    it "processes valid moves" do
      post :make_move, params: { direction: 'right', use_route: :game_2048_make_move }, format: :json
      post :make_move, params: { direction: 'left', use_route: :game_2048_make_move }, format: :json
      post :make_move, params: { direction: 'up', use_route: :game_2048_make_move }, format: :json
      post :make_move, params: { direction: 'down', use_route: :game_2048_make_move }, format: :json
      post :make_move, params: { direction: 'left', use_route: :game_2048_make_move }, format: :json
      post :make_move, params: { direction: 'right', use_route: :game_2048_make_move }, format: :json
      post :make_move, params: { direction: 'down', use_route: :game_2048_make_move }, format: :json
      post :make_move, params: { direction: 'up', use_route: :game_2048_make_move }, format: :json
      expect(response).to have_http_status(:success)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to include(
        'board',
        'score',
        'game_over',
        'won'
      )
    end

    %w[up down left right].each do |direction|
      it "handles #{direction} direction" do
        post :make_move, params: { direction: direction, use_route: :game_2048_make_move }, format: :json
        expect(response).to have_http_status(:success)
      end
    end

    it "handles invalid direction" do
      post :make_move, params: { direction: 'invalid', use_route: :game_2048_make_move }, format: :json
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #new_game" do
    it "starts a new game" do
      post :new_game, params: { use_route: :game_2048_new_game }
      expect(response).to redirect_to(game_2048_play_path)
      expect(session[:game_2048_board]).not_to be_nil
      expect(session[:game_2048_score]).to eq(0)
      expect(session[:game_2048_over]).to be false
      expect(session[:game_2048_won]).to be false
    end
  end

  describe "GET #show" do
    it "redirects to play path" do
      get :show, params: { id: @game.id, use_route: :game_2048_show }
      expect(response).to redirect_to(game_2048_play_path)
    end
  end
end
