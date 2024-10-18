module WordlesHelper
  ALLOWED_GUESSES = (
    File.readlines(Rails.root.join("db/valid_guesses.txt")).map { |word| word.chomp.downcase } +
    File.readlines(Rails.root.join("db/wordle-words.txt")).map { |word| word.chomp.downcase }
  ).uniq.freeze

  def get_definition(word)
    # This is a mock implementation. Replace with actual API call or logic to fetch the definition.
    [{ "shortdef" => ["not satisfied or fulfilled", "not having met"] }]
  end

  def make_guess(given_word)
    session[:wordle_attempts] ||= 0

    if session[:wordle_attempts] >= 6
      @wordle.errors.add(:word, "Exceeded maximum attempts")
      return
    end

    session[:wordle_alphabet_used] ||= []
    session[:wordle_words_guessed] ||= []
    session[:guesses] ||= []
    @wordle.errors.clear

    given_word = given_word.downcase.strip

    unless validate_guess(given_word)
      return
    end

    session[:wordle_attempts] += 1
    session[:wordle_words_guessed] << given_word

    result = check_word(given_word)
    session[:guesses] << result

    if given_word == @wordle.word.downcase
      session[:game_status] = "won"
    elsif session[:wordle_attempts] >= 6
      session[:game_status] = "lost"
    end

    result
  end

  def validate_guess(given_word)
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

    session[:wordle_alphabet_used].each do |letter|
      if given_word.include?(letter)
        @wordle.errors.add(:word, "Letter #{letter} already used")
        return false
      end
    end

    if session[:wordle_words_guessed].include?(given_word)
      @wordle.errors.add(:word, "#{given_word} has already been guessed")
      return false
    end

    if ALLOWED_GUESSES.exclude?(given_word)
      @wordle.errors.add(:word, "#{given_word} is not a valid word")
      return false
    end

    true
  end

  def check_word(given_word)
    given_word = given_word.downcase
    correct_word = @wordle.word.downcase
    results = Array.new(5, "grey")
    letter_count = Hash.new(0)

    correct_word.chars.each { |char| letter_count[char] += 1 }

    5.times do |i|
      if correct_word[i] == given_word[i]
        results[i] = "green"
        letter_count[given_word[i]] -= 1
      end
    end

    5.times do |i|
      if results[i] != "green" && correct_word.include?(given_word[i]) && letter_count[given_word[i]] > 0
        results[i] = "yellow"
        letter_count[given_word[i]] -= 1
      end
    end

    results
  end

  def get_definition(word)
    begin
      response = HTTP.get("https://www.dictionaryapi.com/api/v3/references/collegiate/json/#{word}",
                          params: { key: ENV['MERRIAM_WEBSTER_API_KEY'] })
  
      if response.status.success?
        json_response = response.parse
        if json_response.is_a?(Array) && json_response[0].is_a?(Hash) && json_response[0].key?("shortdef")
          json_response[0]["shortdef"]
        else
          @wordle.errors.add(:word, "Definition for the word couldn't be found")
          []
        end
      else
        @wordle.errors.add(:word, "API call failed with status code #{response.status}")
        []
      end
    rescue StandardError => e
      @wordle.errors.add(:word, "An error occurred: #{e.message}")
      []
    end
  end
  
  

  def reset_game_session(wordle)
    session[:wordle_attempts] = 0
    session[:wordle_alphabet_used] = []
    session[:wordle_words_guessed] = []
    session[:guesses] = []
    session[:game_status] = nil
    @definition = get_definition(@wordle.word)
  end

  def delete_game_session
    session.delete(:wordle_attempts)
    session.delete(:wordle_alphabet_used)
    session.delete(:wordle_words_guessed)
    session.delete(:guesses)
  end
end