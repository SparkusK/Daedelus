class AddUniqueConstraintsOnEmployeesAndSectionsInSupervisors < ActiveRecord::Migration[5.1]
  def change
    # First do Employees
    remove_foreign_key :supervisors, column: :employee_id
    remove_index :supervisors, :employee_id
    add_index :supervisors, :employee_id, unique: true
    add_foreign_key :supervisors, :employees
    # Then do Sections
    remove_foreign_key :supervisors, column: :section_id
    remove_index :supervisors, :section_id
    add_index :supervisors, :section_id, unique: true
    add_foreign_key :supervisors, :sections
  end
end
