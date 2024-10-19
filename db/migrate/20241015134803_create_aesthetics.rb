class CreateAesthetics < ActiveRecord::Migration[7.2]
  def change
    create_table :aesthetics do |t|
      t.integer :game_id
      t.string :primary_clr, default: "#FFFFFF"
      t.string :secondary_clr, default: "#FFFFFF"
      t.string :font_clr, default: "#FFFFFF"
      t.string :font, default: "Verdana, sans-serif"
      t.timestamps
    end
  end
end
