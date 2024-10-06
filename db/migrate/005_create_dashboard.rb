class CreateDashboard < ActiveRecord::Migration[6.1]
  def change
    create_table :dashboard do |t|
      t.integer :total_games_played, default: 0
      t.integer :total_games_won, default: 0
      t.datetime :last_played

      t.timestamps
    end
  end
end
