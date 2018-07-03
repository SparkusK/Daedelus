class RemovePaymentDateFromDebtorPayments < ActiveRecord::Migration[5.1]
  def change
    remove_column :debtor_payments, :payment_date,  :numeric
  end
end
