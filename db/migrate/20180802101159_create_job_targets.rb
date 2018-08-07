class CreateJobTargets < ActiveRecord::Migration[5.1]
  def change
    create_table :job_targets do |t|
      t.references :job, index: true, foreign_key: true, null: false
      t.references :section, index: true, foreign_key: true, null: false
      t.decimal :target_amount, precision: 12, scale: 2, null: false

      t.timestamps
    end
  end
end
