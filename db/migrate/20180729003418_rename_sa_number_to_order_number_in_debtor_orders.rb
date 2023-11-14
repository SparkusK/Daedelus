class RenameSaNumberToOrderNumberInDebtorOrders < ActiveRecord::Migration[5.1]
  def change
    rename_column :debtor_orders, :SA_number, :order_number
  end
end
