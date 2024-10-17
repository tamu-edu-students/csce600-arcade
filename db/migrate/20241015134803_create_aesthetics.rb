class CreateAesthetics < ActiveRecord::Migration[7.2]
  def change
    create_table :aesthetics do |t|
      t.integer :game_id
      t.string :primary_clr
      t.string :secondary_clr
      t.string :font_clr
      t.string :font
      t.timestamps
    end
  end
end
