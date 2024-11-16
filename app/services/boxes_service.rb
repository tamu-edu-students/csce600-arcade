class BoxesService
    def self.set_week_boxes
        tomorrow = Date.tomorrow
        boxes = LetterBox.where(play_date: tomorrow...tomorrow + 7).order(:play_date)
        play_date = boxes.any? ? boxes.maximum(:play_date) : tomorrow
        (play_date..tomorrow + 6).each do |date|
            self.set_day_box(date)
        end
    end

    def self.set_day_box(date = Date.today)
        while LetterBox.find_by(play_date: date).nil?
            letters = get_letters()

            if iterative_path_search(letters).length >= 3
                LetterBox.create(letters: letters.join, play_date: date)
            end
        end
    end

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
            words = WordsService.words_by_first_letter(possible_letters.join)
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

    def self.get_letters
        alphabet = ("a".."z").to_a
        letters = alphabet.shuffle[0, 12]

        while ([ "a", "e", "i", "o", "u" ]-letters).length > 2
            letters = alphabet.shuffle[0, 12]
        end

        letters
    end
end
