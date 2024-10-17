class Game < ApplicationRecord
  validates :name, presence: true

  # Retrieve all games
  def self.all_games
    Game.all
  end
end
