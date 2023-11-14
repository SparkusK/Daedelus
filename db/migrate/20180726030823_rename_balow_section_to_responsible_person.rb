class RenameBalowSectionToResponsiblePerson < ActiveRecord::Migration[5.1]
  def change
    rename_column :jobs, :balow_section, :responsible_person
  end
end
