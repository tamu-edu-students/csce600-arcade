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
