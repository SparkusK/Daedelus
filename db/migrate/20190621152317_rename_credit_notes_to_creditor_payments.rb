class RenameCreditorPaymentsToCreditorPayments < ActiveRecord::Migration[5.1]
  def change
    rename_table :credit_notes, :creditor_payments
  end
end
