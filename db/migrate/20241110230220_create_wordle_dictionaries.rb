class CreateWordleDictionaries < ActiveRecord::Migration[7.2]
  def change
    create_table :wordle_dictionaries do |t|
      t.string :word
      t.boolean :is_valid_solution
      t.timestamps
    end
    add_index :wordle_dictionaries, [ :word ], unique: true, name: 'index_wordle_dictionaries_on_word'
  end
end
