class CreateBee < ActiveRecord::Migration[7.2]
  def change
    create_table :bees do |t|
      t.string :letters, limit: 7
      t.date :play_date

      t.timestamps
    end
  end
end
