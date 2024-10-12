module WordlesHelper
    ALLOWED_GUESSES = (File.readlines(Rails.root.join('db/valid_guesses.txt')).map { |word| word.chomp } + File.readlines(Rails.root.join('db/wordle-words.txt')).map { |word| word.chomp }).uniq.freeze
    
    def make_guess(given_word)
        session[:wordle_attempts] ||= 0
        session[:wordle_alphabet_used] ||= Set.new
        session[:wordle_words_guessed] ||= Set.new

        if session[:wordle_attempts] >= 7 
            @wordle.errors.add(:wordle, "exceeded maximum attempts")
            return
        end

        validate_guess(given_word)
        if @wordle.errors.any? then return end

        session[:wordle_attempts] += 1
        session[:wordle_words_guessed].add(given_word)
        return check_word(given_word)
    end

    def validate_guess(given_word)
        if given_word.blank?
            @wordle.errors.add(:word, "cannot be blank")
        elsif given_word.length != 5
            @wordle.errors.add(:word, "must be 5 characters long")
        elsif /\A[a-z]*\z/i !~ given_word
            @wordle.errors.add(:word, "must only contain english alphabets")
        elsif session[:wordle_words_guessed].include? given_word
            @wordle.errors.add(:word, "#{given_word} has already been guessed")
        elsif ALLOWED_GUESSES.exclude? given_word
            @wordle.errors.add(:word, "#{given_word} invalid")
        else 
            given_word.chars.each { |letter| 
                if session[:wordle_alphabet_used].include? letter 
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
                session[:wordle_alphabet_used].add(given_word[i])
                results[given_word[i]] = "grey"
            end
        end
        return results
    end

    def reset_game_session(wordle)
        session[:wordle_attempts] = 0
        session[:wordle_alphabet_used] = Set.new
        session[:wordle_words_guessed] = Set.new
        @wordle.errors.clear
        @definition = get_definition(@wordle.word)
    end

    def delete_game_session
        session.delete(:wordle_attempts)
        session.delete(:wordle_alphabet_used)
        session.delete(:wordle_words_guessed)
    end

    def get_definition(word)
        return HTTP.get("https://www.dictionaryapi.com/api/v3/references/collegiate/json/#{word}", :params => {:key => "#{ENV['MERRIAM_WEBSTER_API_KEY']}"}).parse.freeze
    end

    def word_definition()
        if @definition.is_a?(Array) && @definition[0].is_a?(Hash)
            return @definition[0]["shortdef"]
        else
            @wordle.errors.add(:definition, "for the word couldn't be found")
        end
    end
end
