module WordlesHelper
  ALLOWED_GUESSES = (
    File.readlines(Rails.root.join("db/valid_guesses.txt")).map { |word| word.chomp.downcase } +
    File.readlines(Rails.root.join("db/wordle-words.txt")).map { |word| word.chomp.downcase }
  ).uniq.freeze

    def make_guess(given_word)
      initialize_guess_session()

      given_word = given_word.downcase.strip

      unless validate_guess(given_word)
        return
      end

      session[:wordle_attempts] += 1
      session[:wordle_words_guessed] << given_word

      result = check_word(given_word)
      session[:guesses] << result

      # Check if the user won (guessed correctly)
      if given_word == @wordle.word.downcase
        session[:game_status] = "won"
      elsif session[:wordle_attempts] >= 6
        session[:game_status] = "lost"
      end

      if session[:game_status].present? and session[:user_id].present?
        game_id = Game.find_by(name: "Wordle").id
        score = session[:game_status] == "won" ? 1 : 0
        DashboardService.new(session[:user_id], game_id, score).call
      end

      result
    end

    def validate_guess(given_word)
      # Ensure all guesses are compared in lowercase
      given_word = given_word.downcase.strip

      if given_word.blank?
        @wordle.errors.add(:word, "cannot be blank")
        return false
      end

      if given_word.length != 5
        @wordle.errors.add(:word, "must be 5 characters long")
        return false
      end

      if /\A[a-z]*\z/i !~ given_word
        @wordle.errors.add(:word, "must only contain English alphabets")
        return false
      end

      # Convert all stored guessed words to lowercase for comparison
      if session[:wordle_words_guessed].map(&:downcase).include?(given_word)
        @wordle.errors.add(:word, "#{given_word} has already been guessed")
        return false
      end

      if ALLOWED_GUESSES.exclude?(given_word)
        @wordle.errors.add(:word, "#{given_word} is not a valid word")
        return false  # Return false on validation failure
      end

      true  # Return true if no validation errors occur
    end

    def check_word(given_word)
      given_word = given_word.downcase  # Ensure consistency with lowercase comparison
      correct_word = @wordle.word.downcase  # Ensure the wordle word is also lowercase for comparison
      results = Array.new(5, "grey")  # Default all results to grey
      letter_count = Hash.new(0)

      # Step 1: Count occurrences of each character in the correct word
      correct_word.chars.each { |char| letter_count[char] += 1 }

      # Step 2: Check for exact matches (green)
      5.times do |i|
        if correct_word[i] == given_word[i]
          results[i] = "green"
          letter_count[given_word[i]] -= 1  # Reduce count for the matched letter
        end
      end

      # Step 3: Check for misplaced matches (yellow) for letters that are still available
      5.times do |i|
        if results[i] != "green" && correct_word.include?(given_word[i]) && letter_count[given_word[i]] > 0
          results[i] = "yellow"
          letter_count[given_word[i]] -= 1  # Reduce count for the used letter
        end
      end

      # Return the color-coded results
      results
    end

    def fetch_todays_word
      Wordle.find_by(play_date: Date.today)&.word || "Word not available"
    end

    def reset_game_session(wordle)
      session[:wordle_attempts] = 0
      session[:wordle_alphabet_used] = []
      session[:wordle_words_guessed] = []
      session[:guesses] = []
      session[:game_status] = nil # Reset the game status
    end

    def initialize_guess_session()
      session[:wordle_attempts] ||= 0
      session[:wordle_alphabet_used] ||= []
      session[:wordle_words_guessed] ||= []
      session[:guesses] ||= []
      @wordle.errors.clear
    end
<<<<<<< HEAD

    private
    def update_stats() 
      if session[:game_status].present? and session[:user_id].present?
        game_id = Game.find_by(name: "Wordle").id
        score = session[:game_status] == "won" ? 1 : 0
        DashboardService.new(session[:user_id], game_id, score).call
      end
    end
=======
>>>>>>> c66d8b5 (fix dashboard integration with wordle and spelling bee)
end
