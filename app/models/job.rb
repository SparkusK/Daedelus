class Job < ApplicationRecord
  belongs_to :section
  belongs_to :order
  belongs_to :quotation
  has_many :labor_records

  def get_supervisor
    Employee.find_by(section_id: section.id, is_supervisor: true)
  end

  def job_name
    @supervisor = get_supervisor
    "Job no. #{id}, supervised by #{@supervisor.first_name}"
  end
end
