class BeesController < ApplicationController
    def index
      @bees = Bee.where(play_date: Date.tomorrow..Date.tomorrow + 6).order(:play_date)

      play_date = @bees.any? ? (@bees.maximum(:play_date)) : Date.tomorrow
      while play_date <= Date.tomorrow + 6
        letters = ("A".."Z").to_a.shuffle[0, 7].join
        valid_words = WordsService.words(letters)
        if valid_words.length > 20
          Bee.create(letters: letters, play_date: play_date)
          play_date += 1
        end
      end

      @bees = Bee.where(play_date: Date.tomorrow..Date.tomorrow + 6).order(:play_date)
    end

    def edit
      @bee = Bee.find(params[:id])
      @valid_words = WordsService.words(@bee.letters)
    end

    def update
      @bee = Bee.find(params[:id])

      if @bee.update(bee_params)
        reset_spelling_bee_session if @bee.play_date == Date.today

        redirect_to edit_bee_path(@bee), notice: "Spelling Bee for #{@bee.play_date.strftime("%B %d")} updated successfully!"
      else
        redirect_to edit_bee_path(@bee), alert: "Invalid update"
      end
    end

    def play
      @bee = Bee.find_by(play_date: Date.today)
      while @bee.nil?
        letters = ("A".."Z").to_a.shuffle[0, 7].join
        valid_words = WordsService.words(letters)
        if valid_words.length > 20
          @bee = Bee.create(letters: letters, play_date: Date.today)
        end
      end
      @aesthetic = Aesthetic.find_by(game_id: Game.find_by(name: "Spelling Bee").id)

      session[:sbscore] ||= 0
      session[:sbwords] ||= []

      render "spellingbee"
    end

    def submit_guess
      @bee = Bee.find_by(play_date: Date.today)

      submitted_word = params[:sbword]

      session[:sbwords] ||= []
      session[:sbscore] ||= 0

      unless session[:sbwords].include?(submitted_word.upcase)
        if valid_word?(submitted_word, @bee.letters[1..6], @bee.letters[0])
          session[:sbwords] << submitted_word.upcase
          score = calculate_score(submitted_word)
          session[:sbscore] += score
          updateStats(score) 
        end
      else
        flash[:sb] = "You have already guessed that!"
      end

      redirect_to bees_play_path
    end

    private

    def bee_params
      params.require(:bee).permit(:letters)
    end

    def valid_word?(word, letters, center)
      return invalid_word_message(word) unless WordsService.word?(word)
      return invalid_center_message(center) unless word.upcase.include?(center)
      return invalid_letters_message(letters) unless word.upcase.chars.all? { |char| letters.include?(char) || char == center.upcase }

      true
    end

    def invalid_word_message(word)
      flash[:sb] = "The word '#{word}' is not in the dictionary."
      false
    end

    def invalid_center_message(center)
      flash[:sb] = "The word must include the center letter '#{center}'."
      false
    end

    def invalid_letters_message(letters)
      flash[:sb] = "The word must be composed of the letters: #{letters.chars.join(', ')}."
      false
    end

    def calculate_score(word)
        word.length - 3
    end

    def reset_spelling_bee_session
      session[:sbwords] = nil
      session[:sbscore] = nil
    end

    def updateStats(score)
      if session[:user_id].present?
        game_id = Game.find_by(name: "Spelling Bee").id
        DashboardService.new(session[:user_id], game_id, score).call
      end
    end
end
