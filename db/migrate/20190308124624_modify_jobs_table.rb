class ModifyJobsTable < ActiveRecord::Migration[5.1]
  # Add Job Number: Unique, Present
  # Delete Targeted Amount
  # Delete Target Date
  # Add Order Number
  # Add Client Section
  def up
    add_column :jobs, :job_number, :string, unique: true, null: false, default: "change_me"
    remove_column :jobs, :targeted_amount
    remove_column :jobs, :target_date
    add_column :jobs, :order_number, :string, null: false, default: "change_me"
    add_column :jobs, :client_section, :string, null: false, default: "change_me"
  end

  def down
    remove_column :jobs, :job_number
    add_column :jobs, :targeted_amount, :decimal, precision: 15, scale: 2, null: false, default: 0
    add_column :jobs, :target_date, :date, null: false
    remove_column :jobs, :order_number
    remove_column :jobs, :client_section
  end

end
