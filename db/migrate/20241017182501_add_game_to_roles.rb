class AddGameToRoles < ActiveRecord::Migration[7.2]
  def change
    add_reference :roles, :game, foreign_key: true, null: true # Allow game_id to be null
  end
end
