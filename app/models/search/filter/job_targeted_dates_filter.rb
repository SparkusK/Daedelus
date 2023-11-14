class Search::Filter::JobTargetedDatesFilter < Search::Filter::AbstractFilter
  def initialize(target_dates)
    @target_dates = target_dates
  end

  def apply(relation)
    filter_by_target_dates(relation, @target_dates)
  end

  def filter_by_target_dates(jobs, target_dates)
    if target_dates.has_start?
      # Jobs for which their earliest Job Target's Date is after the input date
      jobs = jobs.where(id: target_date_jobs(true, target_dates.start_date))
    end
    if target_dates.has_end?
      # Jobs for which their latest Job Target's Date is before the Input Date
      jobs = jobs.where(id: target_date_jobs(false, target_dates.end_date))
    end
    jobs
  end

  def target_date_jobs(start, input_date)
    return [] if !input_date_valid?(input_date)
    if start
      comparator, date_order = '>=', 'ASC'
    else
      comparator, date_order = '<=', 'DESC'
    end
    sql = "SELECT DISTINCT ON (jobs.id) job_id, job_targets.target_date
    FROM jobs
    INNER JOIN job_targets ON job_targets.job_id = jobs.id
    WHERE target_date #{comparator} '#{input_date}'
    ORDER BY jobs.id ASC, job_targets.target_date #{date_order};"
    results = ActiveRecord::Base.connection.execute(sql)
    ids = results.map{|hash| hash["job_id"]}
  end

  def input_date_valid?(date)
    return true if date.is_a?(Date)
    return false if !(/\A\d{4}-\d{2}-\d{2}\z/ =~ date).nil?
    begin
      Date.parse(date)
    rescue ArgumentError
      false
    end
    true
  end

end
