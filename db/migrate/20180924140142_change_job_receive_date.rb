class ChangeJobReceiveDate < ActiveRecord::Migration[5.1]
  def change
    change_column :jobs, :receive_date, :date
  end
end
