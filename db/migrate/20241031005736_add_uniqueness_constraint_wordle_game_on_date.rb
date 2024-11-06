class AddUniquenessConstraintWordleGameOnDate < ActiveRecord::Migration[7.2]
  def change
    add_index :wordles, [ :play_date ], unique: true, name: 'index_wordles_on_play_date'
  end
end
