class CreateWordles < ActiveRecord::Migration[7.2]
  def change
    create_table :wordles do |t|
      t.date :play_date
      t.string :word

      t.timestamps
    end
  end
end
