class WordleValidSolutionsController < ApplicationController
  before_action :set_wordle_valid_solution, only: %i[ show edit update destroy ]

  # GET /wordle_valid_solutions or /wordle_valid_solutions.json
  def index
    @wordle_valid_solutions = WordleValidSolution.all
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
        format.html { redirect_to @wordle_valid_solution, notice: "Wordle valid solution was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wordle_valid_solutions/1 or /wordle_valid_solutions/1.json
  def update
    respond_to do |format|
      if @wordle_valid_solution.update(wordle_valid_solution_params)
        render json: { success: true, notice: 'Update Successful' }, status: 200
      else
        render json: { success: false, notice: 'Update Failed' }, status: 500
      end
    end
  end

  # DELETE /wordle_valid_solutions/1 or /wordle_valid_solutions/1.json
  def destroy
    @wordle_valid_solution.destroy!

    respond_to do |format|
      render json: { success: true }, status: 200
    end
  end

  def update_solutions_dictionary

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
end
