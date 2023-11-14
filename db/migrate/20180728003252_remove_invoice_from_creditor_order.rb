class RemoveInvoiceFromCreditorOrder < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key  :creditor_orders, column: :invoice_id
    remove_index        :creditor_orders, column: :invoice_id
    remove_column       :creditor_orders, :invoice_id
  end
end
