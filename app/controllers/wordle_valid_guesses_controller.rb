class WordleValidGuessesController < ApplicationController
  before_action :set_wordle_valid_guess, only: %i[ update ]
  before_action :validate_bulk_edit_words, only: %i[ add_guesses overwrite_guesses ]

  # GET /wordle_valid_guesses or /wordle_valid_guesses.json
  def index
    @wordle_valid_guesses = WordleValidGuess.order(:word).limit(30)
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
        format.json { render json: { success: true, notice: 'Update Successful' }, status: 200 }
      else
        format.json { render json: { success: false, notice: 'Update Failed' }, status: 500 }
      end
    end
  end

  def add_guesses
    errors = []
  
    params[:new_words_guesses].each do |word|
      begin
        WordleValidGuess.find_or_create_by!(word: word)
      rescue ActiveRecord::RecordInvalid => e
        errors << "Failed to add word '#{word}': #{e.message}"
      end
    end
    
    if errors.empty?
      render json: { success: true }, status: 200
    else
      render json: { success: false, errors: errors }, status: 500
    end
  end

  def overwrite_guesses
    errors = []
    
    ActiveRecord::Base.transaction do
      begin
        WordleValidGuess.destroy_all
  
        params[:new_words_guesses].each do |word|
          WordleValidGuess.find_or_create_by!(word: word)
        end
      rescue ActiveRecord::RecordInvalid => e
        errors << "Failed to overwrite words: #{e.message}"
        raise ActiveRecord::Rollback
      end
    end
    
    if errors.empty?
      render json: { success: true }, status: 200
    else
      render json: { success: false, errors: errors }, status: 500
    end
  end
  

  def reset_guesses

    errors = []
    
    ActiveRecord::Base.transaction do
      begin
        WordleValidGuess.destroy_all
        file_path = Rails.root.join('db/valid_guesses.txt')
        File.readlines(file_path).each do |word|
          WordleValidGuess.create!(word: word.chomp)
        end
      rescue ActiveRecord::RecordInvalid => e
        errors << "Failed to reset words: #{e.message}"
        raise ActiveRecord::Rollback
      end
    end
    
    if errors.empty?
      render json: { success: true }, status: 200
    else
      render json: { success: false, errors: errors }, status: 500
    end
  end

  private
    def set_wordle_valid_guess
      @wordle_valid_guess = WordleValidGuess.find(params[:id])
    end
    
    # Only allow a list of trusted parameters through.
    def wordle_valid_guess_params
      params.require(:wordle_valid_guess).permit(:word)
    end

    def validate_bulk_edit_words
      errors = []
      
      unless params[:new_words_guesses].is_a?(Array)
        errors << "Expected new_words_guesses to be an array"
        render json: { success: false, errors: errors }, status: 500 and return
      end

      
      new_words = params[:new_words_guesses]
      words = new_words.map(&:strip)
      unless words.all? { |word| word.match?(/\A[a-zA-Z]{5}\z/) }
        errors << "Validation failed: all words must have length 5 and must only contain letters"
        render json: { success: false, errors: errors }, status: 500 and return
      end
    end
end
