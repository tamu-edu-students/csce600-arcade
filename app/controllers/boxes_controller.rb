class BoxesController < ApplicationController
  def index
    BoxesService.set_week_boxes()
    @boxes = LetterBox.where(play_date: Date.tomorrow..Date.tomorrow + 6).order(:play_date)
  end

  def edit
    @box = LetterBox.find(params[:id])
  end

  def paths
    paths = BoxesService.iterative_path_search(params[:letters].chars)
    respond_to do |format|
      format.json { render json: { 'paths': paths } }
    end
  end

  def update
    @box = LetterBox.find(params[:id])

    if @box.update(params.require(:letter_box).permit(:letters))
      redirect_to edit_box_path(@box), notice: "Letter Boxed for #{@box.play_date.strftime("%B %d")} updated successfully!"
    else
      redirect_to edit_box_path(@box), alert: "Invalid update"
    end
  end

  def play
    @aesthetic = Aesthetic.find_by(game_id: Game.find_by(name: "Letter Boxed").id)

    @letter_box = LetterBox.find_by(play_date: Date.today)
    while @letter_box.nil?
      @letter_box = LetterBox.create(
          letters: "clueiostjxnk",
          play_date: Date.today
      )
    end

    session[:lbscore] ||= 0
    session[:lbwords] ||= []
    session[:used_letters] ||= []

    @game_won = all_letters_used?
    @used_letters = session[:used_letters]
    @available_letters = get_available_letters
    @words = session[:lbwords]
    render "letterboxed"
  end

  def reset
    session[:lbscore] = 0
    session[:lbwords] = []
    session[:used_letters] = []
    flash[:notice] = "Game has been reset!"
    redirect_to boxes_play_path
  end
  def submit_word
    return if all_letters_used?
    word = params[:lbword].downcase
    @letter_box = LetterBox.find_by(play_date: Date.today)

    if valid_word?(word, session[:lbwords].last)
      session[:lbwords] << word
      session[:lbscore] += 1
      session[:used_letters] |= word.chars
      update_stats(1)

      if all_letters_used?
        flash[:notice] = "Congratulations! You've used all letters in #{session[:lbscore]} words!"
        @game_won = true
      else
        remaining = get_available_letters.join(", ")
        flash[:notice] = "Valid word! Remaining letters: #{remaining}"
      end
    else
      redirect_to boxes_play_path, alert: "Invalid word!"; return
    end

    redirect_to boxes_play_path
  end

  private

  def all_letters_used?
    return false if session[:used_letters].empty?
    game_letters.all? { |letter| session[:used_letters].include?(letter) }
  end

  def game_letters
    LetterBox.find_by(play_date: Date.today).letters.delete("-").chars.uniq
  end

  def get_available_letters
    game_letters - session[:used_letters]
  end

  def valid_word?(word, previous_word = nil)
    return false if previous_word.present? and not word.start_with?(previous_word[-1])
    WordsService.word?(word)
  end

  def update_stats(score)
    if session[:user_id].present?
      game_id = Game.find_by(name: "Letter Boxed").id
      DashboardService.new(session[:user_id], game_id, score).call
    end
  end
end
