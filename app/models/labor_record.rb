class LaborRecord < ApplicationRecord
  belongs_to :employee
  belongs_to :supervisor, optional: true
  belongs_to :job

  # Search by employee.first_name, employee.last_name,
  #   supervisor.first_name, supervisor.last_name, or job.jce_number
  def fuzzy_search(params)

  end
end
