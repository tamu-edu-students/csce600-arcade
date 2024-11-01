class CreateLetterBoxes < ActiveRecord::Migration[7.0]
  def change
    create_table :letter_boxes do |t|
      t.string :letters, null: false
      t.date :play_date, null: false

      t.timestamps
    end

    add_index :letter_boxes, :play_date, unique: true
  end
end