class WordleValidSolutionsController < ApplicationController
  before_action :set_wordle_valid_solution, only: %i[ show edit update destroy ]
  before_action :validate_bulk_edit_words, only: %i[ add_solutions overwrite_solutions ]

  # GET /wordle_valid_solutions or /wordle_valid_solutions.json
  def index
    @wordle_valid_solutions = WordleValidSolution.order(:word).limit(100)
  end

  # GET /wordle_valid_solutions/1 or /wordle_valid_solutions/1.json
  def show
  end

  # GET /wordle_valid_solutions/new
  def new
    @wordle_valid_solution = WordleValidSolution.new
  end

  # GET /wordle_valid_solutions/1/edit
  def edit
  end

  # POST /wordle_valid_solutions or /wordle_valid_solutions.json
  def create
    @wordle_valid_solution = WordleValidSolution.new(wordle_valid_solution_params)

    respond_to do |format|
      if @wordle_valid_solution.save
        format.html { redirect_to @wordle_valid_solution, notice: "Word successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wordle_valid_solutions/1 or /wordle_valid_solutions/1.json
  def update
    respond_to do |format|
      if @wordle_valid_solution.update(wordle_valid_solution_params)
        format.json { render json: { success: true, notice: 'Update Successful' }, status: 200 }
      else
        format.json { render json: { success: false, notice: 'Update Failed' }, status: 500 }
      end
    end
  end

  # DELETE /wordle_valid_solutions/1 or /wordle_valid_solutions/1.json
  def destroy
    @wordle_valid_solution.destroy!

    respond_to do |format|
      format.json { render json: { success: true }, status: 200 }
    end
  end

  def add_solutions
    errors = []
  
    params[:new_words_solutions].each do |word|
      begin
        WordleValidSolution.find_or_create_by!(word: word)
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

  def overwrite_solutions
    errors = []
    
    ActiveRecord::Base.transaction do
      begin
        WordleValidSolution.destroy_all
  
        params[:new_words_solutions].each do |word|
          WordleValidSolution.find_or_create_by!(word: word)
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
  

  def reset_solutions

    errors = []
    
    ActiveRecord::Base.transaction do
      begin
        WordleValidSolution.destroy_all
        file_path = Rails.root.join('db/wordle-words.txt')
        File.readlines(file_path).each do |word|
          WordleValidSolution.create!(word: word.chomp)
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
    # Use callbacks to share common setup or constraints between actions.
    def set_wordle_valid_solution
      @wordle_valid_solution = WordleValidSolution.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def wordle_valid_solution_params
      params.require(:wordle_valid_solution).permit(:word)
    end

    def validate_bulk_edit_words
      errors = []

      unless params[:new_words_solutions].is_a?(Array)
        errors << "Expected new_words_solutions to be an array"
        render json: { success: false, errors: errors }, status: 500 and return
      end

      new_words = params[:new_words_solutions]
      words = new_words.map(&:strip)
      unless words.all? { |word| word.match?(/\A[a-zA-Z]{5}\z/) }
        errors << "Validation failed: all words must have length 5 and must only contain letters"
        render json: { success: false, errors: errors }, status: 500 and return
      end
    end
end
