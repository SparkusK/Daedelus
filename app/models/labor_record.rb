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

  # Search by Employee.first_name, Employee.last_name, JObs.jce_number,
  # Jobs.job_number
  def self.search(keywords, dates, page, section_filter_id)
    # Let's first setup some named conditions on which we want to search
    omit_keywords = keywords.nil? || keywords.empty?
    skip_section_filter = section_filter_id.nil? || section_filter_id.empty?

    # Initialize @labor_records so we don't get NilError
    @labor_records = nil

    # Start by grabbing everything we need according to the search keywords
    unless omit_keywords
      # search everything
      search_term = '%' + keywords.downcase + '%'
      where_term = %{
        ( lower(employees.first_name) LIKE ?
          OR lower(employees.last_name) LIKE ?
          OR lower(jobs.jce_number) LIKE ?
          OR lower(jobs.job_number) LIKE ? )
      }.gsub(/\s+/, " ").strip

      @labor_records = LaborRecord.where(
        where_term,
        search_term,
        search_term,
        search_term,
        search_term
      )
    else
      @labor_records = LaborRecord.all
    end
    @labor_records = @labor_records.joins(:job, :employee)

    # Then reduce the result set by filtering by dates, filters, etc
    if dates.has_start?
      # Labor Records for which Labor Date >= input date
      @labor_records = @labor_records.where("labor_date >= ?", dates.start_date)
    end
    if dates.has_end?
      # Labor Records for which Labor Date <= input date
      @labor_records = @labor_records.where("labor_date <= ?", dates.end_date)
    end
    unless skip_section_filter
      # Filter Labor Records by a specific section
      @labor_records = @labor_records.where(section_id: section_filter_id)
    end


    # Finally, do the ordering and pagination and such
    order_term = "employees.last_name asc, labor_records.labor_date desc"
    @labor_records = @labor_records.order(
      order_term
    ).paginate(
      page: page
    ).includes(
      :section
    )
  end
end
