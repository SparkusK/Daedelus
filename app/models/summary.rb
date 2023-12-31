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

  def month
    Time.now.month
  end

  def time_string_for_this_month(date_field)
    @time = Time.now
    @date = "'#{@time.year}-#{@time.month}-01'::date"
    "WHERE #{date_field} >= #{@date}
       AND #{date_field} < (#{@date} + '1 month'::interval)"
  end

  def sum_for_this_month(sum_field, table, date_field)
    "SELECT SUM(#{sum_field}) FROM #{table} " + time_string_for_this_month(date_field)
  end


  def creditor_orders_for_this_month
    sum_for_this_month("amount_paid", "creditor_payments", "created_at")
  end

  def labor_for_this_month
    sum_for_this_month("total_after", "labor_records", "labor_date")
  end

  def cost(percentage)
    (self.labor.to_f + self.orders.to_f + self.overheads.to_f) * percentage
  end

  def profit(percentage)
    self.target_jobs.to_f - cost(percentage)
  end

  def manager_name(section)
    if section.manager.nil?
      ""
    else
      "#{section.manager.employee.first_name} #{section.manager.employee.last_name}"
    end
  end

  def self.build_summary(section, start_date, end_date)
    @summary = Summary.new
    @summary.is_overall = false
    @summary.header = section.name
    @summary.subheader = @summary.manager_name(section)
    @summary.labor = LaborRecord.where(
        "labor_date >= ? AND labor_date <= ? AND section_id = ?", start_date, end_date, section.id
    ).sum(
        "normal_time_amount_after_tax + overtime_amount_after_tax + sunday_time_amount_after_tax"
    )
    @summary.overheads = Section.find_by(id: section.id).overheads
    @summary.orders = Job.joins(:creditor_orders).where("creditor_orders.date_issued >= ? AND creditor_orders.date_issued <= ? AND jobs.section_id = ?", start_date, end_date, section.id).sum(:value_excluding_tax)
    @summary.target_jobs = JobTarget.where("target_date >= ? AND target_date <= ? AND section_id = ?", start_date, end_date, section.id).sum(:target_amount)
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
    @aggregate.labor = LaborRecord.where("labor_date >= ? AND labor_date <= ?", start_date, end_date).sum("normal_time_amount_after_tax + overtime_amount_after_tax + sunday_time_amount_after_tax")
    @aggregate.overheads = Section.all.sum(:overheads)
    @aggregate.orders = CreditorOrder.where("date_issued >= ?
                                            AND date_issued <= ?",
                                            start_date,
                                            end_date)
                                     .sum(:value_excluding_tax)
    @aggregate.target_jobs = JobTarget.where("target_date >= ? AND target_date <= ?", start_date, end_date).sum(:target_amount)
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
      summary = build_summary(section, start_date, end_date)
      unless summary.labor == 0 && summary.orders == 0 && summary.target_jobs == 0
        @summaries << summary
      end
    end
    @summaries
  end


end
