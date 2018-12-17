class LaborRecord < ApplicationRecord
  belongs_to :employee
  belongs_to :section
  belongs_to :job

  ALLOWED_HOURS = 24
  validates :hours, numericality: { less_than_or_equal_to: ALLOWED_HOURS }

  validates :labor_date, :hours, :normal_time_amount_before_tax,
    :normal_time_amount_after_tax, :overtime_amount_before_tax,
    :overtime_amount_after_tax, :sunday_time_amount_before_tax,
    :sunday_time_amount_after_tax, presence: true

  validates :hours, numericality: { greater_than_or_equal_to: 0.0 }
  validates :hours, numericality: { less_than_or_equal_to: 24.0 }
  validates :normal_time_amount_before_tax,
    :normal_time_amount_after_tax, :overtime_amount_before_tax,
    :overtime_amount_after_tax, :sunday_time_amount_before_tax,
    :sunday_time_amount_after_tax, numericality: { greater_than_or_equal_to: 0.0 }


  def day_of_the_week
    Date::DAYNAMES[self.labor_date.wday]
  end

  def get_section_name
    self.section.nil? ? "" : self.section.name
  end

  # Search by employee.first_name, employee.last_name,
  #   supervisor.first_name, supervisor.last_name, or job.jce_number
  def self.search(keywords, start_date, end_date, page)

    # If there are no keywords, just search dates and paginate and includes:
    if keywords.nil?

      where_term = %{
        labor_records.labor_date >= ? AND labor_records.labor_date <= ?
      }.gsub(/\s+/, " ").strip

      order_term = "employees.first_name asc, labor_records.labor_date desc"

      LaborRecord.joins(
        :employee, :job
      ).where(
        where_term,
        start_date,
        end_date
      ).order(
        order_term
      ).paginate(
        page: page
      ).includes(
        :employee, :job
      )
    # If there are numbers, we only search JCE number
    elsif keywords =~ /\d/

      search_term = '%' + keywords.downcase + '%'

      where_term = %{
        lower(jobs.jce_number) LIKE ?
        AND labor_records.labor_date >= ? AND labor_records.labor_date <= ?
      }.gsub(/\s+/, " ").strip

      order_term = "labor_records.labor_date desc"

      LaborRecord.joins(:job)
      .where(
        where_term,
        search_term,
        start_date,
        end_date
      ).order(
        order_term
      ).paginate(
        page: page
      ).includes(
        :employee, :job
      )
    else
      # search everything
      search_term =  keywords.downcase + '%'
      where_term = %{
        (lower(employees.first_name) || ' ' || lower(employees.last_name)) LIKE ?
        OR lower(jobs.jce_number) LIKE ?
        AND labor_records.labor_date >= ? AND labor_records.labor_date <= ?
      }.gsub(/\s+/, " ").strip

      order_term = "employees.first_name asc, labor_records.labor_date desc"

      LaborRecord.joins(
        :employee, :job
      ).where(
        where_term,
        search_term,
        search_term,
        start_date,
        end_date
      ).order(
        order_term
      ).paginate(
        page: page
      ).includes(
        :employee, :job
      )

    end
  end
end
