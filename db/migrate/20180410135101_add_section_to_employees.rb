class AddSectionToEmployees < ActiveRecord::Migration[5.1]
  def change
    add_reference :employees, :sections, options: { foreign_key: true, null: false }
  end
end
