class AddInvoiceIdToCreditorPayments < ActiveRecord::Migration[5.1]
  def change
    add_reference :credit_notes, :invoice, index: { unique: true }, foreign_key: true
  end
end
