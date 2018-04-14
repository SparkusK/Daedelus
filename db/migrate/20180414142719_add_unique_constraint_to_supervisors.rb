class AddUniqueConstraintToSupervisors < ActiveRecord::Migration[5.1]
  def change
    add_index :supervisors, [:employee_id, :section_id], :unique => true
  end
end
