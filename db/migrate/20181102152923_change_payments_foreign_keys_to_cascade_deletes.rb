class ChangePaymentsForeignKeysToCascadeDeletes < ActiveRecord::Migration[5.1]
  def up
    remove_foreign_key :credit_notes, :creditor_orders
    add_foreign_key :credit_notes, :creditor_orders, on_delete: :cascade
    remove_foreign_key :debtor_payments, :debtor_orders
    add_foreign_key :debtor_payments, :debtor_orders, on_delete: :cascade
  end

  def down
    remove_foreign_key :credit_notes, :creditor_orders
    add_foreign_key :credit_notes, :creditor_orders
    remove_foreign_key :debtor_payments, :debtor_orders
    add_foreign_key :debtor_payments, :debtor_orders
  end
end
