class BoxesController < ApplicationController
  def play
    @aesthetic = Aesthetic.find_by(game_id: Game.find_by(name: "Letter Boxed").id)

    @letter_box = LetterBox.find_by(play_date: Date.today)
    while @letter_box.nil?
      @letter_box = LetterBox.create(
          letters: "clu-esi-toj-xnk",
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
    word = params[:lbword].downcase
    @letter_box = LetterBox.find_by(play_date: Date.today)

    if @letter_box.valid_word?(word, session[:lbwords].last)
      session[:lbwords] << word
      session[:lbscore] += 1
      session[:used_letters] |= word.chars

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
    @game_letters ||= @letter_box.letters.delete("-").chars.uniq
  end

  def get_available_letters
    game_letters - session[:used_letters]
  end
end
