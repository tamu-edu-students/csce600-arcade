class AddGithubUsername < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :github_username, :string
    add_index :users, :github_username, unique: true
  end
end
