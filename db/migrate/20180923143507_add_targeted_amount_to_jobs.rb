class AddTargetedAmountToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :targeted_amount, :decimal, default: 0.0, :precision => 15, :scale => 2
  end
end
