class Summary
  include ActiveModel::Conversion
  include ActiveModel::Model

  attr_accessor :labor, :overheads, :orders, :target_jobs, :header, :subheader, :is_overall

  def persisted?
    false
  end

  def id
    nil
  end

  def get_month
    Time.now.month
  end

  def get_time_string_for_this_month(date_field)
    @time = Time.now
    @date = "'#{@time.year}-#{@time.month}-01'::date"
    "WHERE #{date_field} >= #{@date}
       AND #{date_field} < (#{@date} + '1 month'::interval)"
  end

  def get_sum_for_this_month(sum_field, table, date_field)
    "SELECT SUM(#{sum_field}) FROM #{table} " + get_time_string_for_this_month(date_field)
  end


  def get_creditor_orders_for_this_month
    get_sum_for_this_month("amount_paid", "credit_notes", "created_at")
  end

  def get_labor_for_this_month
    get_sum_for_this_month("total_after", "labor_records", "labor_date")
  end

  def get_cost(percentage)
    (self.labor.to_f + self.orders.to_f + self.overheads.to_f) * percentage
  end

  def get_profit(percentage)
    self.target_jobs.to_f - get_cost(percentage)
  end

  def self.build_summary(section, start_date, end_date)
    @summary = Summary.new
    @summary.is_overall = false
    @summary.header = section.name
    @summary.subheader = get_manager_name(section)
    @summary.labor = LaborRecord.where("labor_date > ? AND labor_date < ? AND section_id = ?", start_date, end_date, section.id).sum(:total_after)
    @summary.overheads = Section.find_by(id: section.id).overheads
    @summary.orders = Job.joins(:creditor_orders).where("receive_date > ? AND receive_date < ? AND section_id = ?", start_date, end_date, section.id).sum(:value_excluding_tax)
    @summary.target_jobs = Job.where("receive_date > ? AND receive_date < ? AND section_id = ?", start_date, end_date, section.id).sum(:targeted_amount)
    @summary
    # Get Labor for Section, Total After
    # Get Overheads for Section
    # Get Jobs for the Section, i.e. jobs = Job.where(section_id: section.id)
    # Get Target Jobs for Section
    # Get Creditor Orders for Section, Including/Excluding?
    # Get Costs
    # Get Profits
  end

  def self.build_aggregate(start_date, end_date)
    @aggregate = Summary.new
    @aggregate.is_overall = true
    @aggregate.header = "Overall"
    @aggregate.labor = LaborRecord.where("labor_date > ? AND labor_date < ?", start_date, end_date).sum(:total_after)
    @aggregate.overheads = Section.all.sum(:overheads)
    @aggregate.orders = CreditorOrder.where("date_issued > ?
                                            AND date_issued < ?",
                                            start_date,
                                            end_date)
                                     .sum(:value_excluding_tax)
    @aggregate.target_jobs = Job.where("receive_date > ? AND receive_date < ?", start_date, end_date).sum(:targeted_amount)
    @aggregate
    # Get Total Labor
    # Get Total Overheads
    # Get Total Job Targets
    # Get Total Creditor Orders for Section
    # Get Costs
    # Get Profits
  end

  def self.build_summaries(start_date, end_date)
    @summaries = []
    @summaries << build_aggregate(start_date, end_date)
    Section.all.each do |section|
      @summaries << build_summary(section, start_date, end_date)
    end
    @summaries
  end

  def get_manager_name(section)
    if section.manager.nil?
      ""
    else
      "#{section.manager.first_name} #{section.manager.last_name}"
    end
  end
end
