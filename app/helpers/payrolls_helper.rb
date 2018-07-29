module PayrollsHelper
  def normal_time_hours(date1, date2)
    # First let's make sure we're starting and ending at the correct dates
    if date1 < date2
      start_date = date1.to_date
      end_date = date2.to_date
    else
      start_date = date2.to_date
      end_date = date1.to_date
    end

    normal_time_hours = 0

    (start_date .. end_date).each do |date|
      case date.wday
      when 1..4
        normal_time_hours += 8.75
      when 5
        normal_time_hours += 5
      end
    end
    normal_time_hours
  end
end
