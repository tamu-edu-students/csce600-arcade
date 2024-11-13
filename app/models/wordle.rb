class Wordle < ApplicationRecord
    validates :word, presence: true, length: { is: 5 }
    validate :valid_solution
    validates :play_date, presence: { message: "has already been set" }, uniqueness: { message: "has already been set" }
    validate :valid_date_after_today, unless: :skip_today_validation?
    validate :valid_date_within_two_weeks

    attr_accessor :skip_today_validation

    def valid_solution
        errors.add(:word, "is not a valid wordle solution") if WordleDictionary.where(word: word, is_valid_solution: true).empty?
    end

    def valid_date_after_today
        errors.add(:play_date, "has to be in the future") if play_date <= Date.today
    end

    def valid_date_within_two_weeks
        errors.add(:play_date, "has to be within the next 2 weeks") if play_date > Date.today+14
    end

    def skip_today_validation?
        skip_today_validation == true
    end
end
