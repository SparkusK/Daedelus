class RenameLaborRecordFields < ActiveRecord::Migration[5.1]
  def up
    rename_column :labor_records, :total_before, :normal_time_amount_before_tax
    rename_column :labor_records, :total_after, :normal_time_amount_after_tax
    rename_column :labor_records, :overtime_before, :overtime_amount_before_tax
    rename_column :labor_records, :overtime_after, :overtime_amount_after_tax
    rename_column :labor_records, :sunday_time_before, :sunday_time_amount_before_tax
    rename_column :labor_records, :sunday_time_after, :sunday_time_amount_after_tax
  end

  def down
    rename_column :labor_records, :normal_time_amount_before_tax, :total_before
    rename_column :labor_records, :normal_time_amount_after_tax, :total_after
    rename_column :labor_records, :overtime_amount_before_tax, :overtime_before
    rename_column :labor_records, :overtime_amount_after_tax, :overtime_after
    rename_column :labor_records, :sunday_time_amount_before_tax, :sunday_time_before
    rename_column :labor_records, :sunday_time_amount_after_tax, :sunday_time_after
  end
end
