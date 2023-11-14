class CleanTheNumbers < ActiveRecord::Migration[5.1]
  def change
    change_column :employees, :net_rate, :decimal, precision: 15, scale: 2, default: 0.0
    change_column :employees, :inclusive_rate, :decimal, precision: 15, scale: 2, default: 0.0
  end
end
