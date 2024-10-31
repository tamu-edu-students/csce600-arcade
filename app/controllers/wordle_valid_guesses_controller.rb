class WordleValidGuessesController < ApplicationController
  before_action :set_wordle_valid_guess, only: %i[ show edit update destroy ]

  # GET /wordle_valid_guesses or /wordle_valid_guesses.json
  def index
    @wordle_valid_guesses = WordleValidGuess.all
  end

  # GET /wordle_valid_guesses/1 or /wordle_valid_guesses/1.json
  def show
  end

  # GET /wordle_valid_guesses/new
  def new
    @wordle_valid_guess = WordleValidGuess.new
  end

  # GET /wordle_valid_guesses/1/edit
  def edit
  end

  # POST /wordle_valid_guesses or /wordle_valid_guesses.json
  def create
    @wordle_valid_guess = WordleValidGuess.new(wordle_valid_guess_params)

    respond_to do |format|
      if @wordle_valid_guess.save
        format.html { redirect_to @wordle_valid_guess, notice: "Wordle valid guess was successfully created." }
        format.json { render :show, status: :created, location: @wordle_valid_guess }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @wordle_valid_guess.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wordle_valid_guesses/1 or /wordle_valid_guesses/1.json
  def update
    respond_to do |format|
      if @wordle_valid_guess.update(wordle_valid_guess_params)
        format.html { redirect_to @wordle_valid_guess, notice: "Wordle valid guess was successfully updated." }
        format.json { render :show, status: :ok, location: @wordle_valid_guess }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @wordle_valid_guess.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wordle_valid_guesses/1 or /wordle_valid_guesses/1.json
  def destroy
    @wordle_valid_guess.destroy!

    respond_to do |format|
      format.html { redirect_to wordle_valid_guesses_path, status: :see_other, notice: "Wordle valid guess was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def update_guesses_dictionary
    @wordle_valid_solution.destroy!

    respond_to do |format|
      format.html { redirect_to wordle_valid_solutions_path, status: :see_other, notice: "Wordle valid solution was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wordle_valid_guess
      @wordle_valid_guess = WordleValidGuess.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def wordle_valid_guess_params
      params.require(:wordle_valid_guess).permit(:word)
    end
end
