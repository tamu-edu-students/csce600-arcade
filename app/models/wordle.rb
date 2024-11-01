class Wordle < ApplicationRecord
    validates :word, presence: true, length: { is: 5 }
    validate :valid_solution
    validates :play_date, presence: { message: "has already been set" }, uniqueness: { message: "has already been set" }

    def valid_solution
        errors.add(:word, "is not a valid wordle solution") if WordleValidSolution.find_by(word: word).nil?
    end
end
