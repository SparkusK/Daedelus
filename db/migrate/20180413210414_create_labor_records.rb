class CreateLaborRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :labor_records do |t|
      t.references :employee, index: true, foreign_key: { to_table: :employees }
      t.string :day_of_the_week
      t.date :labor_date
      t.decimal :hours
      t.decimal :total_before
      t.decimal :total_after
      t.references :supervisor, index: true, foreign_key: { to_table: :employees }
      t.references :job, foreign_key: true

      t.timestamps
    end
  end
end
