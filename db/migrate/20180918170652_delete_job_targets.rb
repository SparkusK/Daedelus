class DeleteJobTargets < ActiveRecord::Migration[5.1]
  def change
    remove_index :job_targets, unique: true, column: [:job_id, :section_id]
    remove_index :job_targets, column: :job_id
    remove_index :job_targets, column: :section_id
    remove_foreign_key :job_targets, column: :section_id
    remove_foreign_key :job_targets, column: :job_id
    drop_table :job_targets
  end
end
