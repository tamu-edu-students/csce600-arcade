class LetterBox < ApplicationRecord
    validates :letters, presence: true
    validates :play_date, presence: true, uniqueness: true

    def self.today
        find_by(play_date: Date.today)
    end

    def letters_by_side
        letters.split("-")
    end

    def valid_word?(word, previous_word = nil)
        return false unless WordsService.word?(word)

        if previous_word.present?
            puts "Previous word: #{previous_word}"
            puts "Start with last letter? #{word.start_with?(previous_word[-1])}"
            return false unless word.start_with?(previous_word[-1])
        end

        true
    end
end
