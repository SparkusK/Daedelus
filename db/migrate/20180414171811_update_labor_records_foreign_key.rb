class UpdateLaborRecordsForeignKey < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :labor_records, column: :supervisor_id
    add_foreign_key :labor_records, :supervisors
  end
end
