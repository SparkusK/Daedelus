class DropInvoicesTable < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :debtor_payments, column: :invoice_id
    remove_column :debtor_payments, :invoice_id
    remove_foreign_key :credit_notes, column: :invoice_id
    remove_column :credit_notes, :invoice_id
    drop_table :invoices
    add_column :debtor_payments, :invoice_code, :string
    add_column :credit_notes, :invoice_code, :string
  end
end
