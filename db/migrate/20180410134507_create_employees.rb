class CreateEmployees < ActiveRecord::Migration[5.1]
  def change
    create_table :employees do |t|
      t.string :first_name
      t.string :last_name
      t.boolean :is_supervisor
      t.string :occupation
      #t.references :section, foreign_key: true
      t.string :company_number
      t.decimal :net_rate, precision: 8, scale: 2
      t.decimal :inclusive_rate, precision: 8, scale: 2

      t.timestamps
    end
  end
end
