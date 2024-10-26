namespace :bee do
    task new_bee: :environment do
        week = Bee.find_by(play_date: Date.today + 7)
        while week.nil?
            letters = ("A".."Z").to_a.shuffle[0, 7].join
            valid_words = WordsService.words(letters)
            if valid_words.length > 20
                week = Bee.create(letters: letters, play_date: Date.today + 7)
            end
        end
    end
end
