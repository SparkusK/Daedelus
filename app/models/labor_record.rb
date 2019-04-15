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

  validates_uniqueness_of :employee_id, scope: %i[labor_date]


  def self.calculate_amounts(employee, date, hours)

    allowed_hours_before_overtime = 0.0
    rate_after_overtime = 1.5
    normal_time_hours = 0.0
    overtime_hours = 0.0
    sunday_time_hours = 0.0

    case date.wday
    when 0 # Sunday
      rate_after_overtime = 2.0
      sunday_time_hours = hours
    when 6 # Saturday
      overtime_hours = hours
    when 5 # Friday
      allowed_hours_before_overtime = 5.0
      if hours > allowed_hours_before_overtime
        normal_time_hours = allowed_hours_before_overtime
        overtime_hours = hours - allowed_hours_before_overtime
      else
        normal_time_hours = hours
      end
    when 1..4 # Monday to Thursday
      allowed_hours_before_overtime = 8.75
      if hours > allowed_hours_before_overtime
        normal_time_hours = allowed_hours_before_overtime
        overtime_hours = hours - allowed_hours_before_overtime
      else
        normal_time_hours = hours
      end
    end

    # Check Amounts[] for abbreviation meanings
    ntb = normal_time_hours * employee.net_rate
    nta = normal_time_hours * employee.inclusive_rate
    otb = overtime_hours * employee.net_rate * rate_after_overtime
    ota = overtime_hours * employee.inclusive_rate * rate_after_overtime
    stb = sunday_time_hours * employee.net_rate * rate_after_overtime
    sta = sunday_time_hours * employee.inclusive_rate * rate_after_overtime

    amounts = Hash.new(0)
    amounts[:normal_time_amount_before_tax] = ntb
    amounts[:normal_time_amount_after_tax] = nta
    amounts[:overtime_amount_before_tax] = otb
    amounts[:overtime_amount_after_tax] = ota
    amounts[:sunday_time_amount_before_tax] = stb
    amounts[:sunday_time_amount_after_tax] = sta

    amounts

  end

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
        :employee, :job, :section
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
        :employee, :job, :section
      )
    else
      # search everything
      search_term = '%' + keywords.downcase + '%'
      where_term = %{
        ((lower(employees.first_name) || ' ' || lower(employees.last_name)) LIKE ?
        OR lower(jobs.jce_number) LIKE ?)
        AND labor_records.labor_date BETWEEN ? AND ?
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
        :employee, :job, :section
      )

    end
  end
end
