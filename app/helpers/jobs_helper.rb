module JobsHelper
  def get_all_jobs
    Job.all
  end

  def get_jobs_by_section(section_id)
    Job.where(section_id: section_id)
  end
end
