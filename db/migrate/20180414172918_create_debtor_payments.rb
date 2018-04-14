class CreateDebtorPayments < ActiveRecord::Migration[5.1]
  def change
    create_table :debtor_payments do |t|
      t.references :debtor_order, foreign_key: true
      t.decimal :payment_amount
      t.datetime :payment_date
      t.string :payment_type
      t.string :note

      t.timestamps
    end
  end
end
