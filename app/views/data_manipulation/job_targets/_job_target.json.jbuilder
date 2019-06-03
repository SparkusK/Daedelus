json.extract! job_target, :id, :target_date, :invoice_number, :remarks, :details, :target_amount, :section_id, :job_id, :created_at, :updated_at
json.url job_target_url(job_target, format: :json)
