class Dashboard < ApplicationRecord
    self.table_name = 'dashboard'
  
    # belongs_to :user
    # has_many :games
  
    def update_statistics(game)
      self.total_games_played += 1
      self.total_games_won += 1 if game.won?
      self.last_played = game.played_on
      # Logic for streaks goes here
      self.save
    end
  end