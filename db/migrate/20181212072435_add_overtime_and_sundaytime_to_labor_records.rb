class AddOvertimeAndSundaytimeToLaborRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :labor_records, :overtime_before, :decimal, precision: 15, scale: 2, null: false, default: 0
    add_column :labor_records, :overtime_after, :decimal, precision: 15, scale: 2, null: false, default: 0
    add_column :labor_records, :sunday_time_before, :decimal, precision: 15, scale: 2, null: false, default: 0
    add_column :labor_records, :sunday_time_after, :decimal, precision: 15, scale: 2, null: false, default: 0
  end
end
