class CreateJobTargets < ActiveRecord::Migration[5.1]
  def change
    create_table :job_targets do |t|
      t.date :target_date, null: false
      t.string :invoice_number, null: false
      t.string :remarks
      t.string :details
      t.decimal :target_amount, precision: 12, scale: 2, null: false
      t.references :section, foreign_key: true, null: false
      t.references :job, foreign_key: true, null: false

      t.timestamps
    end
  end
end
