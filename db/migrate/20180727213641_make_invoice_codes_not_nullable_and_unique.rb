class MakeInvoiceCodesNotNullableAndUnique < ActiveRecord::Migration[5.1]
  def change
    change_column :invoices, :code, :string, null: false
    add_index :invoices, :code, unique: true
  end
end
