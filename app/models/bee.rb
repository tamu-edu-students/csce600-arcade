# This model holds letters for each spelling bee game.
#
# @attr [String] letters The letters of the game. (eg. "ABCDEFG")
# @attr [Date] play_date The date of the game. (eg. '2024-11-08')
#
# @raise [ValidationError] if 'letters' is not made of letters or repeats characters.
class Bee < ApplicationRecord
    validates :letters, presence: true, length: { is: 7 }
    validates :play_date, presence: true, uniqueness: true
    validate :sb_letters
  private

  def sb_letters
    unless letters =~ /\A[a-zA-Z]+\z/
      errors.add(:letters, "must contain only letters")
    end

    unless letters.chars.uniq.length == letters.length
      errors.add(:letters, "must contain unique characters")
    end
  end
end
