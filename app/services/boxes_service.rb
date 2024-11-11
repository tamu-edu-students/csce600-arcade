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
            letters = ("a".."z").to_a.shuffle[0, 12].join
            valid_words = WordsService.words(letters)
            if valid_words.length > 20
                LetterBox.create(letters: letters, play_date: date)
            end
        end
    end
end
