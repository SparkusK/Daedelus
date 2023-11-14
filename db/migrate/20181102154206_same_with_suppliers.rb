class SameWithSuppliers < ActiveRecord::Migration[5.1]
  def up
    remove_foreign_key :creditor_orders, :suppliers
    add_foreign_key :creditor_orders, :suppliers, on_delete: :cascade
  end

  def down
    remove_foreign_key :creditor_orders, :suppliers
    add_foreign_key :creditor_orders, :suppliers
  end
end
