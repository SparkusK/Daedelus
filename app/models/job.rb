class Job < ApplicationRecord
  belongs_to :section
  belongs_to :debtor_order
  belongs_to :quotation
  has_many :labor_records

  def get_supervisor
    Supervisor.find_by(section_id: section.id)
  end

  def job_name
    @supervisor = get_supervisor
    "Job no. #{id}, supervised by #{@supervisor.employee.first_name}"
  end

  # Search by section, jce_number, or quotation
  def fuzzy_search(params)

  end
end
