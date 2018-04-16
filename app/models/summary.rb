class Summary
  include ActiveModel::Conversion
  include ActiveModel::Model

  attr_accessor :labor, :overheads, :orders, :target_jobs

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
    (self.labor.values[0][0].to_f + self.orders.values[0][0].to_f + self.overheads.to_f) * percentage
  end

  def get_profit(percentage)
    self.target_jobs.to_f - get_cost(percentage)
  end
end
