class WordlesController < ApplicationController
  include WordlesHelper

  before_action :ensure_wordle_existence, only: %i[ play ]
  before_action :set_wordle, only: %i[ show edit update destroy play ]
  before_action :check_session_id, except: %i[ play ]
  before_action :restrict_one_day_play, only: %i[ play ]
  before_action :allow_only_future_deletions, only: %i[ destroy ]

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
  #
  # @param [String] sort Specifies the field to sort results by
  # @param [String] asc Specifies the order in which to sort results. true for ASC and false for DESC
  def index
    sort_field = params[:sort]
    asc = params[:asc] =~ /^true$/

    if !sort_field.nil? && asc then @wordles = Wordle.order(sort_field)
    elsif !sort_field.nil? then @wordles = Wordle.order(format("%s DESC", sort_field))
    else @wordles = Wordle.order(format("%s DESC", :play_date))
    end
  end

  # GET /wordles/1 or /wordles/1.json
  # @deprecated no use
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
  # @deprecated no use
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

  # PATCH /wordles/1 or /wordles/1.json
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

  def restrict_one_day_play
    game = Game.find_by(name: "Wordle").id
    last_played = Dashboard.where(user_id: session[:user_id], game_id: game).order(played_on: :desc).first

    if last_played&.played_on == Date.today
        session[:game_status] = last_played&.score == 1 ? "won" : "lost"
        nil
    end
  end

  def ensure_wordle_existence
    if Wordle.where(play_date: Date.today).empty?
      todays_wordle = Wordle.new(play_date: Date.today, word: WordleDictionary.where(is_valid_solution: true).sample.word)
      todays_wordle.skip_today_validation = true
      todays_wordle.save
    end
  end

  def allow_only_future_deletions
    unless @wordle.play_date > Date.today
      @wordle.errors.add(:base, "Can only delete Wordle Plays in the future")
      redirect_to wordles_path, alert: "Can only delete Wordle Plays in the future"
    end
  end
end
