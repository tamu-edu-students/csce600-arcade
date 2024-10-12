class WordlesController < ApplicationController
  before_action :set_wordle, only: %i[ show edit update destroy play]

  # Play: /wordles/play
  def play
  end

  # GET /wordles or /wordles.json
  def index
    @wordles = Wordle.all
  end

  # GET /wordles/1 or /wordles/1.json
  def show
  end

  # GET /wordles/new
  def new
    @wordle = Wordle.new
  end

  # GET /wordles/1/edit
  def edit
  end

  # POST /wordles or /wordles.json
  def create
    @wordle = Wordle.new(wordle_params)

    respond_to do |format|
      if @wordle.save
        format.html { redirect_to @wordle, notice: "Wordle was successfully created." }
        format.json { render :show, status: :created, location: @wordle }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @wordle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wordles/1 or /wordles/1.json
  def update
    respond_to do |format|
      if @wordle.update(wordle_params)
        format.html { redirect_to @wordle, notice: "Wordle was successfully updated." }
        format.json { render :show, status: :ok, location: @wordle }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @wordle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wordles/1 or /wordles/1.json
  def destroy
    @wordle.destroy!

    respond_to do |format|
      format.html { redirect_to wordles_path, status: :see_other, notice: "Wordle was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wordle
      @wordle = Wordle.find_by(play_date: Date.today)
    end

    # Only allow a list of trusted parameters through.
    def wordle_params
      params.require(:wordle).permit(:play_date, :word)
    end
end
