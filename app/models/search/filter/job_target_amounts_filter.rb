class Search::Filter::JobTargetAmountsFilter < Search::Filter::AbstractFilter
  def initialize(target_status)
    @target_status = target_status
  end

  def apply(relation)
    filter_by_target_amounts(relation)
  end

  private

  def filter_by_target_amounts(jobs)
    case @target_status
    when Search::Job::TargetComparisonEnum::NOT_TARGETED
      modifier = '!'
    when Search::Job::TargetComparisonEnum::UNDER_TARGETED
      modifier = '<'
    when Search::Job::TargetComparisonEnum::FULLY_TARGETED
      modifier = '='
    when Search::Job::TargetComparisonEnum::OVER_TARGETED
      modifier = '>'
    else
      return jobs
    end
    jobs.where(id: targeted_records("#{modifier}"))
  end

  def check_modifier_validity(modifier)
    if !(['<', '>', '=', '!']).include? modifier
      raise InvalidModifierError, "An invalid modifier was passed internally to Targeted Records."
    end
  end

  def targeted_records(modifier)
    check_modifier_validity(modifier)
    Job.select("jobs.id, jobs.total, SUM(job_targets.target_amount)")
    .left_outer_joins(:job_targets)
    .group("jobs.id")
    .having(having_clause(modifier))
    .ids
  end

  def having_clause(modifier)
    clause = "SUM(job_targets.target_amount)"
    if modifier == '!'
      clause << not_targeted_records_clause_finish
    else
      clause << targeted_records_clause_finish(modifier)
    end
  end

  def targeted_records_clause_finish(modifier)
    " #{modifier} jobs.total"
  end

  def not_targeted_records_clause_finish
    " IS NULL"
  end
end
