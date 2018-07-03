class LaborRecord < ApplicationRecord
  belongs_to :employee
  belongs_to :supervisor, optional: true
  belongs_to :job

  # Search by employee.first_name, employee.last_name,
  #   supervisor.first_name, supervisor.last_name, or job.jce_number
  def self.search(keywords)

    search_term = '%' + keywords.downcase + '%'

    # If there are numbers, we only search JCE number
    if keywords =~ /\d/
      where_term = %{
        lower(jobs.jce_number) LIKE ?
      }.gsub(/\s+/, " ").strip

      order_term = "labor_records.labor_date desc"

      LaborRecord.joins(:job)
      .where(
        where_term,
        search_term
      ).order(order_term)
    else
      # search everything
      where_term = %{
        lower(employees.first_name) LIKE ?
        OR lower(employees.last_name) LIKE ?
        OR lower(employees_supervisors.first_name) LIKE ?
        OR lower(employees_supervisors.last_name) LIKE ?
        OR lower(jobs.jce_number) LIKE ?
      }.gsub(/\s+/, " ").strip

      order_term = "employees.first_name asc, labor_records.labor_date desc"

      LaborRecord.left_outer_joins(:employee, :job, supervisor: :employee)
      .where(
        where_term,
        search_term,
        search_term,
        search_term,
        search_term,
        search_term
      ).order(order_term)
    end
  end
end
