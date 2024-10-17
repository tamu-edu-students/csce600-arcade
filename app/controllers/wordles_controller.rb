class WordlesController < ApplicationController
  before_action :set_wordle, only: %i[ show edit update destroy play submit_guess ]
  before_action :check_session_id, except: %i[ play submit_guess ]

  # Play: /wordles/play
  def play
  end

  # POST /wordles/submit_guess
  def submit_guess
    given_word = params[:guess]
    results = make_guess(given_word)
    render json: { results: results, attempts: session[:wordle_attempts], errors: @wordle.errors.full_messages }
  end

  # GET /wordles or /wordles.json
  def index
    sort_field = params[:sort]
    asc = params[:asc] =~ /^true$/

    if !sort_field.nil? && asc 
      @wordles = Wordle.order(sort_field)
    elsif !sort_field.nil?
      @wordles = Wordle.order(format("%s DESC", sort_field))
    else
      @wordles = Wordle.all
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

  # Use callbacks to share common setup or constraints between actions.
  def set_wordle
    @wordle = params[:id].nil? ? Wordle.find_by(play_date: Date.today) : Wordle.find_by(id: params[:id])
  end

  # Only allow a list of trusted parameters through.
  def wordle_params
    params.require(:wordle).permit(:play_date, :word)
  end

  # Check if the user is authorized to access certain actions
  def check_session_id
    all_admins_and_setters = Role.where("role = 'System Admin' OR role = 'Puzzle Setter'")
    
    # Only allow access to /wordles/play if user is not logged in
    if session[:user_id].nil? && params[:action] != 'play'
      # Redirect guests trying to access any action other than play
      redirect_to welcome_path, alert: "You are not authorized to access this page."
    elsif !session[:user_id].nil? && all_admins_and_setters.map { |r| r.user_id }.exclude?(session[:user_id])
      # If the user is logged in but does not have the necessary role
      redirect_to welcome_path, alert: "You are not authorized to access this page."
    end
  end
end
