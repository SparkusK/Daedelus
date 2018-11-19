class AddIsFinishedToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :is_finished, :boolean, default: false
  end
end
