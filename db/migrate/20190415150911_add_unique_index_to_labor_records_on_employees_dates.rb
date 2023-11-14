class AddUniqueIndexToLaborRecordsOnEmployeesDates < ActiveRecord::Migration[5.1]
  def change
    add_index :labor_records, [:employee_id, :labor_date], unique: true
  end
end
