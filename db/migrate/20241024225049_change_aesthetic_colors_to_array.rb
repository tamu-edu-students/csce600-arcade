class ChangeAestheticColorsToArray < ActiveRecord::Migration[7.2]
  def change
    remove_column :aesthetics, :primary_clr
    remove_column :aesthetics, :secondary_clr
    remove_column :aesthetics, :tertiary_clr
    remove_column :aesthetics, :font_clr
    remove_column :aesthetics, :primary_clr_label
    remove_column :aesthetics, :secondary_clr_label
    remove_column :aesthetics, :tertiary_clr_label
    remove_column :aesthetics, :font_clr_label

    add_column :aesthetics, :colors, :jsonb
  end
end
