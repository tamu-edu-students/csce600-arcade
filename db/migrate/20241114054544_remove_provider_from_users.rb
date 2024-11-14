class RemoveProviderFromUsers < ActiveRecord::Migration[7.2]
  def change
    remove_column :users, :provider, :string
  end
end
