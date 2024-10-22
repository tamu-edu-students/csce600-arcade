class BeesController < ApplicationController
    def index
      @bees = Bee.where("play_date >= ?", Date.today+1).order(:play_date)

      additional_bees_needed = 7 - @bees.count

      additional_bees_needed.times do |i|
        letters = ("A".."Z").to_a.shuffle[0, 7].join
        Bee.create(letters: letters, play_date: Date.today + @bees.count + i)
      end

      @bees = Bee.where("play_date >= ?", Date.today).order(:play_date).limit(7)
    end

    def edit
      @bee = Bee.find(params[:id])
    end

    def update
      @bee = Bee.find(params[:id])

      if @bee.update(bee_params)
        reset_spelling_bee_session if @bee.play_date == Date.today

        redirect_to bees_path, notice: "Spelling Bee for #{@bee.play_date.strftime("%B %d")} updated successfully!"
      else
        redirect_to bees_path, alert: "Invalid update"
      end
    end

    def play
      @bee = Bee.find_by(play_date: Date.today)
      session[:sbscore] ||= 0
      session[:sbwords] ||= []

      @aesthetic = Aesthetic.find_by(game_id: Game.find_by(name: "Spelling Bee").id)

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
      # 1. word must be in the dictionary
      unless dictionary_check(word)
        flash[:sb] = "The word '#{word}' is not in the dictionary."
        return false
      end

      # 2. word must include the center letter
      word_chars = word.upcase.chars
      unless word_chars.include?(center)
        flash[:sb] = "The word must include the center letter '#{center}'."
        return false
      end

      # 3. word must be composed of valid letters
      unless word_chars.all? { |char| letters.include?(char) || char == center.upcase }
        flash[:sb]  = "The word must be composed of the letters: #{letters.join(', ')}."
        return false
      end
      true
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
end
