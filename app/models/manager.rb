class Manager < ApplicationRecord
  belongs_to :employee
  belongs_to :section


  def manager_name
    "#{employee.first_name} #{employee.last_name}"
  end
  # Search by employee.first_name, employee.last_name, or section.name
  def fuzzy_search(params)


  end

  def self.search(keywords)

    search_term = keywords.downcase + '%'

    where_term = %{
      lower(employees.first_name) LIKE ?
      OR lower(employees.last_name) LIKE ?
      OR lower(sections.name) LIKE ?
    }.gsub(/\s+/, " ").strip

    order_term = "last_name asc"

    Manager.joins(:employee, :section)
    .where(
      where_term,
      search_term,
      search_term,
      search_term
    ).order(order_term)
  end
end
