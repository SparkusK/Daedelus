class DropQuotationsTable < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :jobs, column: :quotation_id
    remove_column :jobs, :quotation_id
    drop_table :quotations
    add_column :jobs, :quotation_code, :string
  end
end
