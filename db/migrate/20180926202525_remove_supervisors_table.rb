class RemoveSupervisorsTable < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :supervisors, :sections
    remove_column :supervisors, :section_id
    remove_foreign_key :supervisors, :employees
    remove_column :supervisors, :employee_id

    drop_table :supervisors
  end
end
