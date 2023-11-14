class RemoveInvoiceFromDebtorOrders < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :debtor_orders, :invoices
    remove_index :debtor_orders, column: :invoice_id
    remove_column :debtor_orders, :invoice_id, :bigint
  end
end
