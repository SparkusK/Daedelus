class RemoveDayOfTheWeekFromLaborRecord < ActiveRecord::Migration[5.1]
  def change
    remove_column :labor_records, :day_of_the_week, :string
  end
end
