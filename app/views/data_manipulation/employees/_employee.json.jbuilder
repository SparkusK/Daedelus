json.extract! employee, :id, :first_name, :last_name, :is_supervisor, :occupation, :section_id, :company_number, :net_rate, :inclusive_rate, :created_at, :updated_at
json.url employee_url(employee, format: :json)
