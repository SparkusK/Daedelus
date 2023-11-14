class DropSupervisorColumnFromEmployees < ActiveRecord::Migration[5.1]
  def change
    remove_column :employees, :is_supervisor
  end
end
