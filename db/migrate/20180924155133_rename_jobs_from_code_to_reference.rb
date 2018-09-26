class RenameJobsFromCodeToReference < ActiveRecord::Migration[5.1]
  def change
    rename_column :jobs, :quotation_code, :quotation_reference
  end
end
