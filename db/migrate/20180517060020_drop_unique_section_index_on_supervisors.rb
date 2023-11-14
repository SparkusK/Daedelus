class DropUniqueSectionIndexOnSupervisors < ActiveRecord::Migration[5.1]
  def up
    remove_index :supervisors, :section_id
  end

  def down
    add_index :supervisors, :section_id, unique: true
  end
end
