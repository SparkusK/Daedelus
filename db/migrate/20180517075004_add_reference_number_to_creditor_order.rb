class AddReferenceNumberToCreditorOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :creditor_orders, :reference_number, :string
  end
end
