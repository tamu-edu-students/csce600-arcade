class WordlesController < ApplicationController
  include WordlesHelper

  before_action :set_wordle, only: %i[ show edit update destroy play ]
  before_action :check_session_id, except: %i[ play ]

  # Play: /wordles/play
  def play
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
    redirect_to wordle_path(@wordle), notice: "#{@wordle.word} for date #{@wordle.play_date} was successfully created."
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
    # all_admins_and_setters = Role.where("role = 'System Admin' OR role = 'Puzzle Setter'")
  
    # if all_admins_and_setters.empty? || session[:user_id].nil?
    #   if action_name == 'play'
    #     return
    #   else
    #     redirect_to welcome_path, alert: "You are not authorized to access this page."
    #   end
    # else
    #   if all_admins_and_setters.map(&:user_id).exclude?(session[:user_id])
    #     if action_name != 'play'
    #       redirect_to wordles_play_path
    #     end
    #   end
    # end
    redirect_to wordles_play_path
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_wordle
    @wordle = params[:id].nil? ? Wordle.find_by(play_date: Date.today) : Wordle.find_by(id: params[:id])
  end

  def wordle_params
    params.require(:wordle).permit(:play_date, :word)
  end
end
