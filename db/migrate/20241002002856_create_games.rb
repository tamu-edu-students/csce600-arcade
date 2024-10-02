class CreateGames < ActiveRecord::Migration[7.2]
  def change
    create_table :games do |t|
      t.string 'name'
      t.string 'game_path'
      t.timestamps
    end
  end
end
