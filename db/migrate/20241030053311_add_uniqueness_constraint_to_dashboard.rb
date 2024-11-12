class AddUniquenessConstraintToDashboard < ActiveRecord::Migration[7.2]
  def change
    add_index :dashboards, [ :user_id, :game_id, :played_on ], unique: true, name: 'index_dashboards_on_user_id_and_game_id_and_played_on'
  end
end
