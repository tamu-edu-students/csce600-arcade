class LetterBox < ApplicationRecord
    validates :letters, presence: true
    validates :play_date, presence: true, uniqueness: true

    def self.today
        find_by(play_date: Date.today)
    end

    def letters_by_side
        letters.split("-")
    end
end
