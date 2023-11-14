class RemoveStillOwedAmountFromDebtorOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :debtor_orders, :still_owed_amount
  end
end
