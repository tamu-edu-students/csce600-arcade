class UpdatingSettingsTable < ActiveRecord::Migration[7.2]
  def change
    add_column :settings, :active_roles, :string
    remove_column :settings, :roles
  end
end
