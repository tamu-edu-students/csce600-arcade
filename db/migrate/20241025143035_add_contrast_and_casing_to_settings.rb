class AddContrastAndCasingToSettings < ActiveRecord::Migration[7.2]
  def change
    add_column :settings, :page_contrast, :int, default: 100
    add_column :settings, :game_font_casing, :boolean, default: true
  end
end
