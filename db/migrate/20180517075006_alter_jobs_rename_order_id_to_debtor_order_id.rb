class AlterJobsRenameOrderIdToDebtorOrderId < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :jobs, column: :order_id
    remove_index :jobs, :order_id
    rename_column :jobs, :order_id, :debtor_order_id
    add_index :jobs, :debtor_order_id
    add_foreign_key :jobs, :debtor_orders
  end
end
