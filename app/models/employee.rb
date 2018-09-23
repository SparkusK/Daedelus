class Employee < ApplicationRecord
  belongs_to :section
  has_many :labor_records
  has_one :supervisor
  has_one :manager

  def employee_name
    "#{first_name} #{last_name}"
  end

  # Labor Records should only be able to choose Employees that are not fired
  def self.valid
    Employee.except(eoc: true)
  end
  # Search by first_name, last_name, occupation, section, or company number
  def self.search(keywords)

    search_term = keywords.downcase + '%'
    search_term_occupation = '%' + keywords.downcase + '%'
    search_term_company_number = '%' + keywords.downcase + '%'
    search_term_section_name = '%' + keywords.downcase + '%'

    where_term = %{
      lower(employees.first_name) LIKE ?
      OR lower(employees.last_name) LIKE ?
      OR lower(employees.occupation) LIKE ?
      OR lower(employees.company_number) LIKE ?
      OR lower(sections.name) LIKE ?
    }.gsub(/\s+/, " ").strip

    order_term = "last_name asc"

    Employee.joins(:section)
    .where(where_term,
      search_term,
      search_term,
      search_term_occupation,
      search_term_company_number,
      search_term_section_name
    ).order(order_term)
  end


end
