# This model represents the Dictionary used by Wordle.
# It contains a list of all valid 5 letter guesses and all valid 5 letter solutions
#
# @attr [String] word The 5 letter Word
# @attr [Boolean] is_valid_solution Specifies whether the word is a valid solution or not
#
# @raise [ValidationError] if the word is missing, not 5 characters or already exists
class WordleDictionary < ApplicationRecord
    validates :word, presence: true, length: { is: 5 }, uniqueness: true
end
