class SetForeignKeyOnDeleteFromJobTargetsToSectionsToCascadeInsteadOfDelete < ActiveRecord::Migration[5.1]
  def up
    remove_foreign_key :job_targets, :sections
    add_foreign_key :job_targets, :sections, on_delete: :nullify
  end

  def down
    remove_foreign_key :job_targets, :sections
    add_foreign_key :job_targets, :sections, on_delete: :nullify
  end
end
