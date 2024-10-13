class GamesController < ApplicationController
  before_action :set_game, only: %i[ show ]

  # GET /games or /games.json
  def index
    @games = Game.all
    @current_user = User.find(session[:user_id]) if session[:user_id]
  end

  # GET /games/1 or /games/1.json
  def show
    @game = Game.find(params[:id])
    redirect_to send(@game.game_path)
  end

  def demo_game
    @game = Game.find(params[:id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end
end
