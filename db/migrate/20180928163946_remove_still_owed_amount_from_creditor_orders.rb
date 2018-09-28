class RemoveStillOwedAmountFromCreditorOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :creditor_orders, :still_owed_amount
  end
end
