class ChangeJobTargetedNull < ActiveRecord::Migration[5.1]
  def change
    change_column_null :jobs, :targeted_amount, false, 0.0
  end
end
