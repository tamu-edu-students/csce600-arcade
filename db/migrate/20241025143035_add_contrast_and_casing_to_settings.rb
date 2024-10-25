class AddContrastAndCasingToSettings < ActiveRecord::Migration[7.2]
  def change
    add_column :settings, :page_contrast, :int, default: 100
    add_column :settings, :wordle_upper_casing, :boolean, default: true
  end
end
