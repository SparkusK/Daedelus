class ChangeJobTotal < ActiveRecord::Migration[5.1]
  def change
    change_column_null :jobs, :total, false, 0.0
    change_column :jobs, :total, :numeric, default: 0.0, precision: 15, scale: 2, null: false
  end
end
