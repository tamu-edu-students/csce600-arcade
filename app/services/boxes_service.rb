class BoxesService
    # Sets the puzzles for the next week
    def self.set_week_boxes
        tomorrow = Date.tomorrow
        boxes = LetterBox.where(play_date: tomorrow...tomorrow + 7).order(:play_date)
        play_date = boxes.any? ? boxes.maximum(:play_date) : tomorrow
        (play_date..tomorrow + 6).each do |date|
            self.set_day_box(date)
        end
    end

    # Sets the puzzle for a given day
    def self.set_day_box(date = Date.today)
        while LetterBox.find_by(play_date: date).nil?
            letters = get_letters()

            if iterative_path_search(letters).length >= 3
                LetterBox.create(letters: letters.join, play_date: date)
            end
        end
    end

    # Find a number of word sequences less where each sequence is less than 6 words long and contains all letters
    #
    # @param [Array<String>] letters that can be used
    # @param [Integer] n_paths the number of paths that should be found
    # @return [Array<Array<String>>] the paths found
    def self.iterative_path_search(letters, n_paths = 3)
        @valid_paths = []
        @max_depth = 2
        @possible_words = {}
        @num_of_paths = n_paths
        patterns = [ letters[0..2], letters[3..5], letters[6..8], letters[9..11] ]
        letters.each_with_index do |l, i|
            possible_letters = letters.map(&:clone)
            possible_letters.slice!(3*(i/3), 3)
            possible_letters.insert(0, l)
            words = WordsService.words(possible_letters.join, true)
            patterns.each do |p|
                words = words.select { |w| not w.match(/[#{p}][#{p}]+/) }
            end

            return @valid_paths if words.empty?

            @possible_words[l] = words
        end
        while @max_depth < 6 and @valid_paths.length < @num_of_paths
            find_paths(letters, letters)
            @max_depth += 1
        end

        @valid_paths
    end

    # Find a sequence of words that contain all remaining letters according to Letter Boxed rules
    #
    # @param [Array<String>] remaining_letters letters left to be used
    # @param [String] last word in the current sequence (if any)
    # @param [Array<String>] curr_path currrent sequence of words
    # @param [Integer] depth current depth
    # @return [nil]
    def self.find_paths(remaining_letters, last_word = nil, curr_path = [], depth = 0)
        if remaining_letters.empty? and not @valid_paths.include? curr_path
            @valid_paths << curr_path
        end

        if @valid_paths.length >= @num_of_paths
            false
        else
            if depth < @max_depth
                if last_word.nil?
                    words = @possible_words.values.flatten.select { |w| not curr_path.include? w }
                else
                    words = @possible_words[last_word.last].select { |w| not curr_path.include? w }
                end
                words.sort_by { |w| (remaining_letters-w.chars.uniq).length }
                                .each do |word|
                    still_searching = find_paths(remaining_letters - word.chars.uniq, word, curr_path+[ word ], depth + 1)
                    return if not still_searching
                end
            end
            true
        end
    end

    # Generates 12 random letters for Letter Boxed with at least 3 vocals
    # @return [Array<String>] 12 letters
    def self.get_letters
        alphabet = ("a".."z").to_a
        letters = alphabet.shuffle[0, 12]

        while ([ "a", "e", "i", "o", "u" ]-letters).length > 2
            letters = alphabet.shuffle[0, 12]
        end

        letters
    end
end
