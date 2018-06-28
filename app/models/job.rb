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

  # Search by:
  #   sections.name,
  #   jobs.contact_person,
  #   jobs.balow_section,
  #   jobs.work_description (if " ".count > 1)
  #   debtor_orders.?
  #   quotations.code
  #   jobs.jce_number
  def self.search(keywords)

    # If there are numbers, we only search:
    #   JCE number, balow section, quotation code
    # Else search everything
    search_term = keywords.downcase + '%'

    where_term = %{
      lower(first_name) LIKE ?
      OR lower(last_name) LIKE ?
    }.gsub(/\s+/, " ").strip

    order_term = "last_name asc"

    Employee.where(where_term, search_term, search_term).order(order_term)
  end
end
