class CreateCreditorOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :creditor_orders do |t|
      t.references :supplier, foreign_key: true
      t.references :job, foreign_key: true
      t.references :invoice, foreign_key: true
      t.string :delivery_note
      t.datetime :date_issued
      t.decimal :value_excluding_tax
      t.decimal :tax_amount
      t.decimal :value_including_tax
      t.decimal :still_owed_amount

      t.timestamps
    end
  end
end
