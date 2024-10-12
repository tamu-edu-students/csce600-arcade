module WordlesHelper
    ALLOWED_GUESSES = (File.readlines(Rails.root.join('db/valid_guesses.txt')).map { |word| word.chomp } + File.readlines(Rails.root.join('db/wordle-words.txt')).map { |word| word.chomp }).uniq.freeze
    
    def make_guess(given_word)
        session[:attempts] ||= 0
        session[:attempts] += 1
        session[:alphabet_used] ||= Set.new
        @wordle.errors.clear

        if session[:attempts] >= 7 
            @wordle.errors.add(:wordle, "exceeded maximum attempts")
            return
        end

        validate_guess(given_word)
        if @wordle.errors.any? then return end

        return check_word(given_word)
    end

    def validate_guess(given_word)
        if given_word.blank?
            @wordle.errors.add(:word, "cannot be blank")
        elsif given_word.length < 5
            @wordle.errors.add(:word, "must be at least 5 characters long")
        elsif /\A[a-z]*\z/i !~ given_word
            @wordle.errors.add(:word, "must only contain english alphabets")
        elsif ALLOWED_GUESSES.exclude? given_word
            @wordle.errors.add(:word, "#{given_word} invalid")
        else 
            given_word.chars.each { |letter| 
                if session[:alphabet_used].include? letter 
                    @wordle.errors.add(:letter, "letter #{letter} already used")
                    return
                end
            }
        end
    end

    def check_word(given_word)
        results = {}
        5.times do |i|
            if @wordle.word[i] == given_word[i]
                results[given_word[i]] = "green"
            elsif @wordle.word.include? given_word[i]
                results[given_word[i]] = "yellow"
            else
                session[:alphabet_used].add(given_word[i])
                results[given_word[i]] = "grey"
            end
        end
        return results
    end

    def reset_game_session(wordle)
        session.delete(:attempts)
        session.delete(:alphabet_used)
        @definition = HTTP.get("https://www.dictionaryapi.com/api/v3/references/collegiate/json/#{@wordle.word}", :params => {:key => "#{ENV['MERRIAM_WEBSTER_API_KEY']}"}).parse.freeze
    end

    def get_definition()
        if @definition.is_a?(Array) && @definition[0].is_a?(Hash)
            return @definition[0]["shortdef"]
        else
            @wordle.errors.add(:definition, "for the word couldn't be found")
        end
    end
end
