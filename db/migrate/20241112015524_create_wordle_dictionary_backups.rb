class CreateWordleDictionaryBackups < ActiveRecord::Migration[7.2]
  def change
    create_table :wordle_dictionary_backups do |t|
      t.string :word
      t.boolean :is_valid_solution
      t.timestamps
    end
    add_index :wordle_dictionary_backups, [ :word ], unique: true, name: 'index_wordle_dictionary_backups_on_word'
  end
end
