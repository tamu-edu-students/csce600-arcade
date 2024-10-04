class CreateRoles < ActiveRecord::Migration[7.2]
  def change
    create_table :roles do |t|
      t.references :user, null: false, foreign_key: true # user_id as a foreign key to users table
      t.string :role # Column for role

      t.timestamps
    end
  end
end
