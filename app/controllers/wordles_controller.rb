class WordlesController < ApplicationController
  include WordlesHelper

  before_action :set_wordle, only: %i[ show edit update destroy play ]
  before_action :check_session_id, except: %i[ play ]

  # Play: /wordles/play
  def play
    @aesthetic = Aesthetic.find_by(game_id: Game.find_by(name: "Wordle").id)
    @definition = WordsService.define(@wordle.word)
    params[:game_id] ||= 2
    session[:wordle_alphabet_used] ||= []
    session[:wordle_words_guessed] ||= []

    if params[:reset]
      reset_game_session(@wordle)
    elsif params[:guess]
      make_guess(params[:guess])
    end
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
    if Role.exists?(user_id: session[:user_id], role: "Puzzle Setter")
      @wordle = Wordle.new
    else
      redirect_to wordles_play_path
    end
  end

  # GET /wordles/1/edit
  def edit
  end

  # POST /wordles or /wordles.json
  def create
    @wordle = Wordle.new(wordle_params)
    if @wordle.save
      redirect_to wordle_path(@wordle), notice: "#{@wordle.word} for date #{@wordle.play_date} was successfully created."
    else
      render :new
    end
  end

  # PATCH/PUT /wordles/1 or /wordles/1.json
  def update
    @wordle = Wordle.find(params[:id])
    if @wordle.update(wordle_params)
      redirect_to wordle_path(@wordle), notice: "#{@wordle.word} for date #{@wordle.play_date} was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /wordles/1 or /wordles/1.json
  def destroy
    @wordle = Wordle.find(params[:id])
    @wordle.destroy
    redirect_to wordles_path, notice: "Wordle #{@wordle.word} for date #{@wordle.play_date} deleted."
  end

  private

  def check_session_id
    if session[:guest] == true
      redirect_to wordles_play_path and return
    end

    all_admins_and_setters = Role.where("role = 'System Admin' OR role = 'Puzzle Setter'")

    if all_admins_and_setters.empty?
      redirect_to welcome_path, alert: "You are not authorized to access this page."
    elsif all_admins_and_setters.map(&:user_id).exclude?(session[:user_id])
      redirect_to wordles_play_path
    end
  end

  def set_wordle
    @wordle = params[:id].nil? ? Wordle.find_by(play_date: Date.today) : Wordle.find_by(id: params[:id])
  end

  def wordle_params
    params.require(:wordle).permit(:play_date, :word)
  end
end
