# This model represents the daily Wordle plays.
#
# @attr [Date] play_date The date for which the word is to be set
# @attr [String] word The word to be set as the solution for a given date
# @attr [Boolean] skip_today_validation Flag used to specifiy that validating play_date in the past should be skipped.
#
# @raise [ValidationError] if the word is missing or not 5 characters
# @raise [ValidationError] if the word is not a valid solution from the WordleDictionary
# @raise [ValidationError] if the play_date has already been set
# @raise [ValidationError] if the play_date is in the past or beyond 2 weeks into the future
class Wordle < ApplicationRecord
    validates :word, presence: true, length: { is: 5 }
    validate :valid_solution
    validates :play_date, presence: { message: "has already been set" }, uniqueness: { message: "has already been set" }
    validate :valid_date_after_today, unless: :skip_today_validation?
    validate :valid_date_within_two_weeks

    attr_accessor :skip_today_validation

    # Validates that the word exists in WordleDictionary as a valid solution
    def valid_solution
        errors.add(:word, "is not a valid wordle solution") if WordleDictionary.where(word: word, is_valid_solution: true).empty?
    end

    # Validates that the play_date is not in the past (including today)
    def valid_date_after_today
        errors.add(:play_date, "has to be in the future") if play_date <= Date.today
    end

    # Validates that the play_date is not beyond two weeks into the future
    def valid_date_within_two_weeks
        errors.add(:play_date, "has to be within the next 2 weeks") if play_date > Date.today+14
    end

    # Flag to allow new Wordle Plays to be created in the past, used to set today's play if a Puzzle Setter hasn't set it beforehand
    def skip_today_validation?
        skip_today_validation == true
    end
end
