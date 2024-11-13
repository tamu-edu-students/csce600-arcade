# This model represents the Backup Dictionary used by Wordle.
# It is loaded once at the time of creation and never modified.
# It is used to reset the active Wordledictionary to a default version when requested by a Puzzle Setter
#
# @attr [String] word The 5 letter Word
# @attr [Boolean] is_valid_solution Specifies whether the word is a valid solution or not
#
# @raise [ValidationError] if the word is missing, not 5 characters or already exists
class WordleDictionaryBackup < ApplicationRecord
    validates :word, presence: true, length: { is: 5 }, uniqueness: true
end
