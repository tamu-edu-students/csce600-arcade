class Game < ApplicationRecord
  validates :name, presence: true

  has_one :aesthetic
  has_many :roles

  def self.all_games
    [ "Wordle", "Spelling Bee", "Letter Boxed" ]
  end
end
