class CreateRoles < ActiveRecord::Migration[7.2]
  def change
    create_table :roles do |t|
      t.string :name
<<<<<<< HEAD
      t.references :user, foreign_key: true
=======
      t.references :user, null: false, foreign_key: true
>>>>>>> ef609d2 (basic model migration)

      t.timestamps
    end
  end
end
