class CreateJobs < ActiveRecord::Migration[5.1]
  def change
    create_table :jobs do |t|
      t.datetime :receive_date
      t.references :section, foreign_key: true
      t.string :contact_person
      t.string :balow_section
      t.decimal :total
      t.string :work_description
      t.string :jce_number
      t.references :order, foreign_key: true
      t.references :quotation, foreign_key: true

      t.timestamps
    end
  end
end
