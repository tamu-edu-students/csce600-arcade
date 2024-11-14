class AddImageUrlToGames < ActiveRecord::Migration[7.2]
  def change
    add_column :games, :image_url, :string
  end
end
