class Wordle < ApplicationRecord
    validates :word, presence: true
end
