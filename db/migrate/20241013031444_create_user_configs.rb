class CreateUserConfigs < ActiveRecord::Migration[7.2]
  def change
    create_table :user_configs do |t|
      t.text :roles, default: ""
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
