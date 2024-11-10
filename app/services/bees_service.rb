# Handles logic of spelling bee
class BeesService
    # This method sets the upcoming 7 bee games
    #
    # @return [nil]
    def self.set_week_bee
        tomorrow = Date.tomorrow
        bees = Bee.where(play_date: tomorrow...tomorrow + 7).order(:play_date)
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
    # @param [Array<String>] sbwords list of found words
    # @param [Integer] sbscore current score
    # @return [Array<String>]  sbwords updated list of found words
    # @return [Integer] sbscore updated score
    # @return [String] message information about guess
    def self.guess(word, sbwords = [], sbscore = 0)
        word = word.upcase
        message = nil

        if sbwords.include?(word)
            message = "You have already guessed that!"
        else
            message = valid_word?(word)
            if message == "valid"
                message = ""
                sbwords << word
                sbscore += calculate_score(word)
            end
        end

        return sbwords, sbscore, message
    end

    private

    def self.valid_word?(word)
        bee = Bee.find_by(play_date: Date.today)
        letters = bee.letters[1..6]
        center = bee.letters[0]

        return "The word '#{word}' is not in the dictionary." unless WordsService.word?(word)
        return "The word must include the center letter '#{center}'." unless word.include?(center)
        return "The word must be composed of the letters: #{letters.join(', ')}." unless word.chars.all? { |char| letters.include?(char) || char == center.upcase }

        "valid"
    end

    def self.calculate_score(word)
        word.length - 3
    end
end
