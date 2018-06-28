class Supervisor < ApplicationRecord
  belongs_to :employee
  belongs_to :section
  has_many :labor_records

  def supervisor_name
    "#{employee.first_name} #{employee.last_name}"
  end


  def self.search(keywords)

    search_term = keywords.downcase + '%'

    where_term = %{
      lower(employees.first_name) LIKE ?
      OR lower(employees.last_name) LIKE ?
      OR lower(sections.name) LIKE ?
    }.gsub(/\s+/, " ").strip

    order_term = "last_name asc"

    Supervisor.joins(:employee, :section)
    .where(where_term,
      search_term,
      search_term,
      search_term
    ).order(order_term)
  end

  validates :employee_id, presence: true
    # , message: "A Section has to be supervised by an Employee."
  validates :section_id, presence: true
    # , message: "A Supervisor has to supervise a Section."

    # Search by employee.first_name, employee.last_name, or section.name
    def fuzzy_search(params)


    end

end
