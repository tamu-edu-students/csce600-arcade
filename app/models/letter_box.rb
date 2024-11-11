class LetterBox < ApplicationRecord
    validates :letters, presence: true, length: { is: 12 }
    validates :play_date, presence: true, uniqueness: true
    validate :lb_letters
  private

  def lb_letters
    unless letters =~ /\A[a-zA-Z]+\z/
      errors.add(:letters, "must contain only letters")
    end

    unless letters.chars.uniq.length == letters.length
      errors.add(:letters, "must contain unique characters")
    end
  end
end
