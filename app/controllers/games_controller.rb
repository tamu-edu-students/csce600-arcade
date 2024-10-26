class GamesController < ApplicationController
  before_action :set_game, only: %i[ show ]

  # GET /games or /games.json
  def index
    @games = Game.where("id != -1")
    @current_user = User.find(session[:user_id]) if session[:user_id]
  end

  def show
    @game = Game.find(params[:id])
    begin
      redirect_to send(@game.game_path)
    rescue NoMethodError
      redirect_to games_path, alert: "Game path not found."
    end
  end

  def demo_game
    @game = Game.find(params[:id])
  end

  private
  def set_game
    @game = Game.find(params[:id])
  end
end
