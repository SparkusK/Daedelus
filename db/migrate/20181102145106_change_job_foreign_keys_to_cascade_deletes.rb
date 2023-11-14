class ChangeJobForeignKeysToCascadeDeletes < ActiveRecord::Migration[5.1]
  def up
    remove_foreign_key :creditor_orders, :jobs
    remove_foreign_key :debtor_orders, :jobs
    remove_foreign_key :labor_records, :jobs

    add_foreign_key :labor_records, :jobs, on_delete: :cascade
    add_foreign_key :debtor_orders, :jobs, on_delete: :cascade
    add_foreign_key :creditor_orders, :jobs, on_delete: :cascade
  end

  def down
    remove_foreign_key :creditor_orders, :jobs
    remove_foreign_key :debtor_orders, :jobs
    remove_foreign_key :labor_records, :jobs

    add_foreign_key :labor_records, :jobs
    add_foreign_key :debtor_orders, :jobs
    add_foreign_key :creditor_orders, :jobs
  end
end
