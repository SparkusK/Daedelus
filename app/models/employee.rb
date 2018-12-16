class Employee < ApplicationRecord
  belongs_to :section
  has_many :labor_records
  has_one :manager

  validates :first_name, :last_name, :occupation, :company_number, presence: true

  # Employee
  #   -> Manager (1)
  #   -> Labor Record

  def self.get_labor_records(employee_id)
    LaborRecord.where("employee_id = ?", employee_id)
  end

  def self.get_manager(employee_id)
    Manager.find_by(employee_id: employee_id)
  end

  def self.get_entities(employee_id)
    labor_records  = get_labor_records( employee_id )
    manager        = get_manager(       employee_id )
    (manager.nil? )? manager_count = 0 : manager_count = 1
    {
      labor_records: labor_records,
      manager_count: manager_count
    }
  end


  def self.get_removal_confirmation(employee_id)
    entities = get_entities(employee_id)
    confirmation = "Performing this removal will also delete: \n"

    confirmation << "* #{entities[:labor_records].count} Labor Records \n"
    confirmation << "* #{entities[:manager_count]} Manager records \n"

    confirmation << "Are you sure?"
  end

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

    if search_term.split.length > 1 # search_term has spaces
      where_term = %{
        (lower(employees.first_name) || ' ' || lower(employees.last_name)) LIKE ?
        OR lower(employees.occupation) LIKE ?
        OR lower(employees.company_number) LIKE ?
        OR lower(sections.name) LIKE ?
      }.gsub(/\s+/, " ").strip

      order_term = "first_name asc"

      Employee.joins(:section)
      .where(where_term,
        search_term,
        search_term_occupation,
        search_term_company_number,
        search_term_section_name
      ).order(order_term)
    else
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


end
