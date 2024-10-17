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
    @sbletters = [ "A", "B", "C", "D", "O", "F" ]
    @sbcenter = "T"
    @sbscore = session[:sbscore] || 0
    @sbwords = session[:sbwords] || []
    @aesthetic = Aesthetic.find_by(game_id: params[:id].to_i)

    if request.post?
      submitted_word = params[:sbword]
      session[:sbwords] ||= []
      if valid_word?(submitted_word, @sbletters, @sbcenter)
        unless session[:sbwords].include?(submitted_word)
          session[:sbwords] << submitted_word.upcase
          session[:sbscore] = session[:sbscore].to_i + calculate_score(submitted_word)
          @sbwords = session[:sbwords]
          @sbscore = session[:sbscore]
        end
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
    # 1. word must include the center letter
    word_chars = word.upcase.chars
    unless word_chars.include?(center)
      @error_message = "The word must include the center letter '#{center}'."
      return false
    end

    # 2. word must be composed of valid letters
    unless word_chars.all? { |char| letters.include?(char) || char == center.upcase }
      @error_message = "The word must be composed of the letters: #{letters.join(', ')}."
      return false
    end

    # 3. word must be at least 4 letters long
    if word.length < 4
      @error_message = "The word must be at least 4 letters long."
      return false
    end

    # 4. word must not have been used before
    if session[:sbwords]&.include?(word.upcase)
      @error_message = "You have already used the word '#{word.upcase}'."
      return false
    end

    # 5. word must be in the dictionary
    unless dictionary_check(word)
      @error_message = "The word '#{word}' is not in the dictionary."
      return false
    end

    true
  end

  def dictionary_check(word)
    api_key = ENV["MERRIAM_WEBSTER_API_KEY"]
    response = HTTP.get("https://www.dictionaryapi.com/api/v3/references/collegiate/json/#{word}", params: { key: api_key })
    return false unless response.status.success?
    parsed_response = response.parse
    parsed_response.is_a?(Array) && parsed_response.any? && parsed_response[0].is_a?(Hash)
  end

  def calculate_score(word)
      word.length * 10
  end
end
