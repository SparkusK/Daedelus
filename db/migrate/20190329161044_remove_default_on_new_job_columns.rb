class RemoveDefaultOnNewJobColumns < ActiveRecord::Migration[5.1]
  def up
    change_column_default(:jobs, :job_number, nil)
    change_column_default(:jobs, :order_number, nil)
    change_column_default(:jobs, :client_section, nil)
  end

  def down
    change_column_default(:jobs, :job_number, "change_me")
    change_column_default(:jobs, :order_number, "change_me")
    change_column_default(:jobs, :client_section, "change_me")
  end
end
