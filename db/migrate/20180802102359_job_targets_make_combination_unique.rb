class JobTargetsMakeCombinationUnique < ActiveRecord::Migration[5.1]
  def change
    #add_index :job_targets, [:job_id, :section_id], :unique => true
  end
end
