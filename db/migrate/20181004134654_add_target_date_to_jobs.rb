class AddTargetDateToJobs < ActiveRecord::Migration[5.1]
  def up
    add_column :jobs, :target_date, :date
  end

  def down
    remove_column :jobs, :target_date
  end
end
