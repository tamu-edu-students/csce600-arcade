class Game < ApplicationRecord
  validates :name, presence: true

  has_one :aesthetic
  has_many :roles

  def self.all_games
    Game.all.filter { |g| g.id != -1 }.map { |g| g.name }
  end
end
