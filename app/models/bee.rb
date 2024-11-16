  # This model holds letters for each spelling bee game.
  #
  # @attr [String] letters The letters of the game. (eg. "ABCDEFG")
  # @attr [Date] play_date The date of the game. (eg. '2024-11-08')
  # @attr [Array<Integer>] ranks The rank ranges for the game. (eg. [5, 10, 20, 40])
  #
  # @raise [ValidationError] if 'letters' is not made of letters or repeats characters.
  # @raise [ValidateError] if 'ranks' is not an integer array of 4 numbers.
  class Bee < ApplicationRecord
      validates :letters, presence: true, length: { is: 7 }
      validates :play_date, presence: true, uniqueness: true
      validate :sb_letters
      validate :sb_rank
    private

    def sb_letters
      unless letters =~ /\A[a-zA-Z]+\z/
        errors.add(:letters, "must contain only letters")
      end

      unless letters.chars.uniq.length == letters.length
        errors.add(:letters, "must contain unique characters")
      end
    end

    def sb_rank
      if !ranks.is_a?(Array) || ranks.length != 4 || ranks.any? { |r| !r.is_a?(Integer) }
        errors.add(:ranks, "must have exactly 4 integer numbers")
      end
    end
  end
