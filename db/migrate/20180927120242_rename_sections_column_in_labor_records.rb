class RenameSectionsColumnInLaborRecords < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :labor_records, :sections
    remove_index :labor_records, column: :sections_id
    rename_column :labor_records, :sections_id, :section_id
    add_index :labor_records, :section_id
    add_foreign_key :labor_records, :sections
  end
end
