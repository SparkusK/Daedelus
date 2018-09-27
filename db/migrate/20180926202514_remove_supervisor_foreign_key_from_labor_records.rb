class RemoveSupervisorForeignKeyFromLaborRecords < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :labor_records, :supervisors
    remove_column :labor_records, :supervisor_id
    add_reference :labor_records, :sections, foreign_key: true
  end
end
