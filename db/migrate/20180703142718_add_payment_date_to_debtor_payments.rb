class AddPaymentDateToDebtorPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :debtor_payments, :payment_date, :datetime
  end
end
