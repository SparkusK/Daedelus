class CreateCreditNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :credit_notes do |t|
      t.references :creditor_order, foreign_key: true
      t.string :payment_type
      t.decimal :amount_paid
      t.string :note

      t.timestamps
    end
  end
end
