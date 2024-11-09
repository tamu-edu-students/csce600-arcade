# Handles logic of spelling bee
class BeesService
    # This method sets the upcoming 7 bee games
    #
    # @return [nil]
    def self.set_week_bee
        tomorrow = Date.tomorrow
        bees = Bee.where(play_date: tomorrow...tomorrow + 6).order(:play_date)
        play_date = bees.any? ? bees.maximum(:play_date) : tomorrow
        (play_date..tomorrow + 6).each do |date|
            self.set_day_bee(date)
        end
    end

    # This method generates a random game
    #
    # @param [Date] date for which you want to create a game
    # @return [nil]
    def self.set_day_bee(date = Date.today)
        while Bee.find_by(play_date: date).nil?
            letters = ("A".."Z").to_a.shuffle[0, 7].join
            valid_words = WordsService.words(letters)
            if valid_words.length > 20
                Bee.create(letters: letters, play_date: date)
            end
        end
    end

    # This method validates a guess
    #
    # @note This method updates session variables
    # @param [String] word guess for the game
    # @return [nil]
    def self.guess(word)
        session[:sbwords] ||= []
        session[:sbscore] ||= 0

        submitted_word = word.upcase

        if session[:sbwords].include?(submitted_word)
            flash[:sb] = "You have already guessed that!"
        else
            if valid_word?(submitted_word)
                session[:sbwords] << submitted_word
                score = calculate_score(submitted_word)
                session[:sbscore] += score
                update_stats(score)
            end
        end
    end

    private

    def valid_word?(word)
        letters = @bee.letters[1..6]
        center = @bee.letters[0]

        return invalid_word_message(word) unless WordsService.word?(word)
        return invalid_center_message(center) unless word.include?(center)
        return invalid_letters_message(letters) unless word.chars.all? { |char| letters.include?(char) || char == center.upcase }

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
        flash[:sb] = "The word must be composed of the letters: #{letters.join(', ')}."
        false
    end

    def calculate_score(word)
        word.length - 3
    end

    def reset_spelling_bee_session
        session[:sbwords] = nil
        session[:sbscore] = nil
    end

    def update_stats(score)
        if session[:user_id].present?
            game_id = Game.find_by(name: "Spelling Bee").id
            DashboardService.new(session[:user_id], game_id, score).call
        end
    end
end
