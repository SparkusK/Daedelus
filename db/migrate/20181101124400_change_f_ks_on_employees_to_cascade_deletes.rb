class ChangeFKsOnEmployeesToCascadeDeletes < ActiveRecord::Migration[5.1]
  def up
    remove_foreign_key :managers, :employees
    remove_foreign_key :labor_records, :employees
    add_foreign_key :labor_records, :employees, on_delete: :cascade
    add_foreign_key :managers, :employees, on_delete: :cascade
  end

  def down
    remove_foreign_key :labor_records, :employees
    remove_foreign_key :managers, :employees
    add_foreign_key :managers, :employees
    add_foreign_key :labor_records, :employees
  end
end
