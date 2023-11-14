class ChangeJobTotalNumeric < ActiveRecord::Migration[5.1]
  def change
    change_column :jobs, :total, :decimal, precision: 15, scale: 2
  end
end
