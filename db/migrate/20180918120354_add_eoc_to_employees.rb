class AddEocToEmployees < ActiveRecord::Migration[5.1]
  def change
    add_column :employees, :eoc, :boolean
  end
end
