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

  def spellingbee
    @sbletters = ['A', 'B', 'C', 'D', 'O', 'F']
    @sbcenter = 'T'
    @sbscore = session[:sbscore] || 0
    @sbwords = session[:sbwords] || []
    @aesthetic =  Aesthetic.find_by(game_id: params[:id].to_i)

    if request.post?
      submitted_word = params[:sbword]
      session[:sbwords] ||= []
      if valid_word?(submitted_word, @sbletters, @sbcenter) && !session[:sbwords].include?(submitted_word)
        session[:sbwords] << submitted_word.upcase
        session[:sbscore] = session[:sbscore].to_i + calculate_score(submitted_word)
        @sbwords = session[:sbwords]
        @sbscore = session[:sbscore]
      end
    end
    render "spellingbee"
end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end


    # Only allow a list of trusted parameters through.
    def game_params
      params.require(:game).permit(:name, :game_path)
    end

    def valid_word?(word, letters, center)
      word_chars = word.upcase.chars
      center_used = word_chars.include?(center)
      return false unless center_used
      all_letters_valid = word_chars.all? { |char| letters.include?(char) || char == center.upcase }
      all_letters_valid
    end
  
  def calculate_score(word)
      word.length * 10
  end
end
