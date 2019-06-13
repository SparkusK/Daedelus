module JobsHelper
  def all_jobs
    Job.all
  end

  def jobs_by_section(section_id)
    Job.where(section_id: section_id)
  end
end
