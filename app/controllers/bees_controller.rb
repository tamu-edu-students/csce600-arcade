class BeesController < ApplicationController
    def index
      @bees = Bee.where(play_date: Date.tomorrow..Date.tomorrow + 7).order(:play_date)

      play_date = @bees.any? ? (@bees.maximum(:play_date) + 1) : Date.tomorrow
      while play_date <= Date.tomorrow + 7
        letters = ("A".."Z").to_a.shuffle[0, 7].join      
        valid_words = fetch_words(letters)
        if valid_words.length > 20
          play_date += 1
          Bee.create(letters: letters, play_date: play_date)
        end
      end

      @bees = Bee.where(play_date: Date.tomorrow..Date.tomorrow + 7).order(:play_date)
    end

    def edit
      @bee = Bee.find(params[:id])
      @valid_words = fetch_words(@bee.letters)
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
        valid_words = fetch_words(letters)
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
          session[:sbscore] += calculate_score(submitted_word)
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
      return invalid_word_message(word) unless dictionary_check(word)
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

    def dictionary_check(word)
      api_key = ENV["MERRIAM_WEBSTER_API_KEY"]
      response = HTTP.get("https://www.dictionaryapi.com/api/v3/references/collegiate/json/#{word}", params: { key: api_key })
      return false unless response.status.success?
      parsed_response = response.parse
      parsed_response.is_a?(Array) && parsed_response.any? && parsed_response[0].is_a?(Hash)
    end

    def calculate_score(word)
        word.length - 3
    end

    def reset_spelling_bee_session
      session[:sbwords] = nil
      session[:sbscore] = nil
    end

  def fetch_words(letters)
    uri = URI("https://api.datamuse.com/words?sp=#{URI.encode_www_form_component("*#{letters[0]}*+#{letters}")}&md=f")
    response = Net::HTTP.get(uri)
    words = JSON.parse(response)
    usable_words = words.select do |word_data|
      f = word_data['tags'][0].match(/f:(\d+\.\d+)/)[1].to_f
      word_data['word'].length > 3 && f > 0.5 && !word_data['word'].include?(" ")
    end.map { |word_data| word_data['word'] }
    usable_words
  end
end
