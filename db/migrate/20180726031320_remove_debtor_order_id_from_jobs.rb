class RemoveDebtorOrderIdFromJobs < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :jobs, :debtor_orders
    remove_index :jobs, column: :debtor_order_id
    remove_column :jobs, :debtor_order_id, :bigint
  end
end
