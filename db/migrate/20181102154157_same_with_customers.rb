class SameWithCustomers < ActiveRecord::Migration[5.1]
  def up
    remove_foreign_key :debtor_orders, :customers
    add_foreign_key :debtor_orders, :customers, on_delete: :cascade
  end

  def down
    remove_foreign_key :debtor_orders, :customers
    add_foreign_key :debtor_orders, :customers
  end
end
