class ChangeSectionRefereeForeignKeysToCascadeDeletes < ActiveRecord::Migration[5.1]
  def up
    remove_foreign_key :jobs, :sections
    remove_foreign_key :employees, :sections
    remove_foreign_key :managers, :sections
    remove_foreign_key :labor_records, :sections
    
    add_foreign_key :labor_records, :sections, on_delete: :cascade
    add_foreign_key :managers, :sections, on_delete: :cascade
    add_foreign_key :employees, :sections, on_delete: :cascade
    add_foreign_key :jobs, :sections, on_delete: :cascade
  end

  def down
    remove_foreign_key :jobs, :sections
    remove_foreign_key :employees, :sections
    remove_foreign_key :managers, :sections
    remove_foreign_key :labor_records, :sections

    add_foreign_key :labor_records, :sections
    add_foreign_key :managers, :sections
    add_foreign_key :employees, :sections
    add_foreign_key :jobs, :sections
  end
end
