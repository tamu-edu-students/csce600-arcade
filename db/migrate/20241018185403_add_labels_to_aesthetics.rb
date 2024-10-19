class AddLabelsToAesthetics < ActiveRecord::Migration[7.2]
  def change
    add_column :aesthetics, :primary_clr_label, :string, default: "Primary Color"
    add_column :aesthetics, :secondary_clr_label, :string, default: "Secondary Color"
    add_column :aesthetics, :font_clr_label, :string, default: "Font Color"
    add_column :aesthetics, :tertiary_clr, :string, default: "#FFFFFF"
    add_column :aesthetics, :tertiary_clr_label, :string, default: "Tertiary Color"
  end
end
