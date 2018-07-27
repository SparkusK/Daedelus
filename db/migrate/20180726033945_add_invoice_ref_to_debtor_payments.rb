class AddInvoiceRefToDebtorPayments < ActiveRecord::Migration[5.1]
  def change
    add_reference :debtor_payments, :invoice, foreign_key: true
  end
end
