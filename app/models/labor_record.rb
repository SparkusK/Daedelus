class LaborRecord < ApplicationRecord
  belongs_to :employee
  belongs_to :supervisor, optional: true
  belongs_to :job

  # Search by employee.first_name, employee.last_name,
  #   supervisor.first_name, supervisor.last_name, or job.jce_number
  def fuzzy_search(params)


  end

  def self.search(keywords)

    search_term = keywords.downcase + '%'

    where_term = %{
      lower(first_name) LIKE ?
      OR lower(last_name) LIKE ?
    }.gsub(/\s+/, " ").strip

    order_term = "last_name asc"

    Employee.where(where_term, search_term, search_term).order(order_term)
  end
end
