class FixJobTargetForeignKey < ActiveRecord::Migration[5.1]
  def up
    remove_foreign_key :job_targets, :jobs
    remove_foreign_key :job_targets, :sections
    add_foreign_key :job_targets, :sections, on_delete: :nullify
    add_foreign_key :job_targets, :jobs, on_delete: :cascade
  end

  def down
    remove_foreign_key :job_targets, :jobs
    remove_foreign_key :job_targets, :sections
    add_foreign_key :job_targets, :sections
    add_foreign_key :job_targets, :jobs
  end
end
