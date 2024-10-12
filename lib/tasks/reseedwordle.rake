namespace :wordle do
    desc "Reseed Wordle Database Table when words run out"
    task add_new_wordle_words: :environment do
        last_date = Wordle.all.empty? ? Date.today : Wordle.order(:play_date).last.play_date
        return unless last_date == Date.today

        file_path = Rails.root.join('db/wordle-words.txt')
        file_words = File.readlines(file_path).map { |word| word.chomp }
        existing_words = Wordle.all.map {|word| word.word.chomp}
        new_words = file_words - existing_words
        new_start_date = last_date + 1

        30.times do |i|
            word_index = rand(0..new_words.length)
            Wordle.create!(play_date: new_start_date + i, word: new_words[word_index])
            new_words.delete_at(word_index)
        end
    end
end