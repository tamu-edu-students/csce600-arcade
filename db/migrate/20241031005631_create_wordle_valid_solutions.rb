class CreateWordleValidSolutions < ActiveRecord::Migration[7.2]
  def change
    create_table :wordle_valid_solutions do |t|
      t.string :word

      t.timestamps
    end
  end
end
