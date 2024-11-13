class DropOldWordleSetterTables < ActiveRecord::Migration[7.2]
  def change
    drop_table :wordle_valid_solutions
    drop_table :wordle_valid_guesses
  end
end
