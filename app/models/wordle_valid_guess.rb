class WordleValidGuess < ApplicationRecord
    validates :word, presence: true, length: { is: 5 }, uniqueness: true
end
