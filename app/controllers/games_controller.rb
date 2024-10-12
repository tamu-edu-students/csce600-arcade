class GamesController < ApplicationController
  before_action :set_game, only: %i[ show edit update destroy ]

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

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games or /games.json
  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: "Game was successfully created." }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1 or /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: "Game was successfully updated." }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1 or /games/1.json
  def destroy
    @game.destroy!

    respond_to do |format|
      format.html { redirect_to games_path, status: :see_other, notice: "Game was successfully destroyed." }
      format.json { head :no_content }
    end
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
