class MakeIndexOnDebtorPaymentToInvoicesUnique < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :debtor_payments, column: :invoice_id
    remove_index :debtor_payments, :invoice_id
    add_index :debtor_payments, :invoice_id, unique: true
    add_foreign_key :debtor_payments, :invoices
  end
end
