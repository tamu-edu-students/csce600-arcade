class WordlesController < ApplicationController
  before_action :set_wordle, only: %i[ show edit update destroy play]
  before_action :check_session_id, except: %i[ play ]

  # Play: /wordles/play
  def play
  end

  # GET /wordles or /wordles.json
  def index
    sort_field = params[:sort]
    asc = params[:asc] =~ /^true$/

    if !sort_field.nil? && asc then @wordles = Wordle.order(sort_field)
    elsif !sort_field.nil? then @wordles = Wordle.order(format('%s DESC', sort_field))
    else @wordles = Wordle.all
    end
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
    @wordle = Wordle.create!(wordle_params)
    redirect_to wordle_path(@wordle), notice: "#{@wordle.word} for date #{@wordle.play_date}  was successfully created."
  end

  # PATCH/PUT /wordles/1 or /wordles/1.json
  def update
    @wordle = Wordle.find params[:id]
    @wordle.update!(wordle_params)
    redirect_to wordle_path(@wordle), notice: "#{@wordle.word} for date #{@wordle.play_date} was successfully updated."
  end

  # DELETE /wordles/1 or /wordles/1.json
  def destroy
    @wordle = Wordle.find(params[:id])
    @wordle.destroy
    redirect_to wordles_path, notice: "Wordle #{@wordle.word} for date #{@wordle.play_date} deleted."
  end

  private
  def check_session_id
    all_admins_and_setters = Role.where("role = 'System Admin' OR role = 'Puzzle Setter'")
    if all_admins_and_setters.empty? || session[:user_id].nil? 
      redirect_to welcome_path, alert: "You are not authorized to access this page."
    elsif all_admins_and_setters.map { |r| r.user_id }.exclude? session[:user_id]
      redirect_to welcome_path, alert: "You are not authorized to access this page."
    end
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_wordle
      @wordle = params[:id].nil? ? Wordle.find_by(play_date: Date.today) : Wordle.find_by(id: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def wordle_params
      params.require(:wordle).permit(:play_date, :word)
    end
end
