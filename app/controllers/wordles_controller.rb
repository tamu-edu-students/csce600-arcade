class WordlesController < ApplicationController
  before_action :set_wordle, only: %i[ show edit update destroy play]

  # Play: /wordles/play
  def play
    guesses = 0
    
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
    # reseed words everytime table data runs out
    def add_new_words
      last_date = Wordle.order(:play_date).last.play_date
      return unless last_date == Date.today

      file_path = '../../migrate/words.txt'
      file_words = Fie.readlines(file_path).each { |word| word.chomp }
      existing_words = Wordle.all.word
      new_words = file_words - existing_words
      new_start_date = last_date + 1

      30.times do |i|
        word_index = rand(0..new_words.length)
        Wordle.create!(play_date: new_start_date + i, word: new_words[word_index])
        new_words.delete_at(word_index)
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_wordle
      @wordle = Wordle.find_by(play_date: Date.today)
    end

    # Only allow a list of trusted parameters through.
    def wordle_params
      params.require(:wordle).permit(:play_date, :word)
    end
end
