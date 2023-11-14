class ImposeNotNullConstraintOnLaborRecordsLaborDate < ActiveRecord::Migration[5.1]
  def change
    change_column_null :labor_records, :labor_date, false
  end
end
