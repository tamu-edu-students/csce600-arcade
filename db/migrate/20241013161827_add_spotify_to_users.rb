class AddSpotifyToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :spotify_username, :string
    add_index :users, :spotify_username, unique: true
  end
end
