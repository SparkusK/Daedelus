class LaborRecord < ApplicationRecord
  include Searchable
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

  def section_name
    self.section.nil? ? "" : self.section.name
  end

  private

# ======= SEARCH ========================================

  def self.keyword_search_attributes
    %w{ employees.first_name employees.last_name jobs.jce_number jobs.job_number }
  end

  def self.subclassed_filters(args)
    filters = []
    filters << Search::Filter::SectionIdFilter.new(args[:section_filter_id])
    filters << Search::Filter::DateRangeFilter.new("labor_date", args[:labor_dates])
    filters
  end

  def self.subclassed_search_defaults
    {
      labor_dates: Utility::DateRange.new(start_date: nil, end_date: nil),
      section_filter_id: nil
    }
  end

  def self.subclassed_order_term
    "employees.last_name asc, labor_records.labor_date desc"
  end

  def self.subclassed_join_list
    [ :job, :employee ]
  end

  def self.subclassed_includes_list
    :section
  end
end
