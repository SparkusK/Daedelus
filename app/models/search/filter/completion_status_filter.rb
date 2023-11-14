class Search::Filter::CompletionStatusFilter < Search::Filter::AbstractFilter
  def initialize(completion_status)
    @completion_status = completion_status
  end

  def apply(relation)
    filter_by_completion_status(relation)
  end

  private

  def filter_by_completion_status(jobs)
    case @completion_status
    when Search::Job::CompletionStatusEnum::NOT_FINISHED
      modifier = 'f'
    when Search::Job::CompletionStatusEnum::FINISHED
      modifier = 't'
    else
      return jobs
    end
    jobs.where("jobs.is_finished = '#{modifier}'")
  end
end
