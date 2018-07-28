class AddOverheadToSection < ActiveRecord::Migration[5.1]
  def change
    add_column :sections, :overheads, :decimal, precision: 12, scale: 2, default: 0.00
  end
end
