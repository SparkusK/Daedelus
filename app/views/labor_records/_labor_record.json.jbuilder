json.extract! labor_record, :id, :employee_id, :day_of_the_week, :labor_date, :hours, :total_before, :total_after, :supervisor_id_id, :job_id, :created_at, :updated_at
json.url labor_record_url(labor_record, format: :json)
