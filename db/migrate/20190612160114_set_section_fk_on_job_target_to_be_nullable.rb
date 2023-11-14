class SetSectionFkOnJobTargetToBeNullable < ActiveRecord::Migration[5.1]
  def up
    change_column_null :job_targets, :section_id, true
  end

  def down
    change_column_null :job_targets, :section_id, false
  end
end
