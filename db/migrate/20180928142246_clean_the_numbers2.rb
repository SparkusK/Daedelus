class CleanTheNumbers2 < ActiveRecord::Migration[5.1]
  def change
    change_column :labor_records, :hours, :decimal, precision: 6, scale: 4, default: 0.0
    change_column :labor_records, :total_before, :decimal, precision: 15, scale: 2, default: 0.0
    change_column :labor_records, :total_after, :decimal, precision: 15, scale: 2, default: 0.0
    change_column :debtor_orders, :value_including_tax, :decimal, precision: 15, scale: 2, default: 0.0
    change_column :debtor_orders, :value_excluding_tax, :decimal, precision: 15, scale: 2, default: 0.0
    change_column :debtor_orders, :tax_amount, :decimal, precision: 15, scale: 2, default: 0.0
    change_column :debtor_orders, :still_owed_amount, :decimal, precision: 15, scale: 2, default: 0.0
    change_column :debtor_payments, :payment_amount, :decimal, precision: 15, scale: 2, default: 0.0
    change_column :creditor_orders, :value_including_tax, :decimal, precision: 15, scale: 2, default: 0.0
    change_column :creditor_orders, :value_excluding_tax, :decimal, precision: 15, scale: 2, default: 0.0
    change_column :creditor_orders, :tax_amount, :decimal, precision: 15, scale: 2, default: 0.0
    change_column :creditor_orders, :still_owed_amount, :decimal, precision: 15, scale: 2, default: 0.0
    change_column :credit_notes, :amount_paid, :decimal, precision: 15, scale: 2, default: 0.0
  end
end
