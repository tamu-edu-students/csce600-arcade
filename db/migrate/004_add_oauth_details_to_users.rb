class AddOauthDetailsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :uid, :string
    add_column :users, :provider, :string
  end
end
