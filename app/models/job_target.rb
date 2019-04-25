class JobTarget < ApplicationRecord
  belongs_to :section
  belongs_to :job

  validates :target_date, :invoice_number, :target_amount, presence: true

  validates :target_amount, numericality: { greater_than: 0.0 }

  def get_available_amount
    total = self.job.total
    payments = JobTarget.where(job_id: self.job_id).sum(:target_amount)
    total - payments
  end

  def get_removal_confirmation(job_target_id)
    "Performing this action will permanently delete this record from the database. Are you sure?"
  end

  # Right, so, technically, the "remaining amount" should indicate
  # how much money can still be allocated towards the job, via job targets,
  # before they hit the estimated total in `Job.total`.
  # The problem is that a simple
  # JobTarget.where(this_job_id).sum(target_amount)
  # will _also_ include the current JobTarget, which we are actively editing.
  # So, we want to _exclude_ the *current* Job Target, and then add the
  # Target Amount inside the actual box to that. We'll handle that via Javascript,
  # because I don't want input from a textbox travelling across the Internet
  # and then touching our servers. Y'know, security conscious and all that.
  #
  # Apparently, a simple .not() should work. Let's see.
  def get_amounts(job_id)
    job_total = self.job.total
    payments = JobTarget
      .where(job_id: job_id)
      .where.not(id: self.id)
      .sum(:target_amount)
    remaining_amount = job_total - payments
    amounts = {remaining_amount: remaining_amount, job_total: job_total}
  end

  def self.get_amounts_for_new_job_target(job_id)
    job_total = Job.find_by(id: job_id).total
    payments = JobTarget.where(job_id: job_id).sum(:target_amount)
    remaining_amount = job_total - payments
    amounts = {remaining_amount: remaining_amount, job_total: job_total}
  end

  def self.search(keywords, target_start_date, target_end_date,
        page, section_filter_id)
    # Let's first setup some named conditions on which we want to search
    has_target_start = !target_start_date.nil? && !target_start_date.empty?
    has_target_end = !target_end_date.nil? && !target_end_date.empty?
    omit_keywords = keywords.nil? || keywords.empty?
    skip_section_filter = section_filter_id.nil? || section_filter_id.empty?


    @job_targets = nil # Initialize @job_targets so we don't get NilError


    # Start by grabbing everything we need according to the search keywords
    unless omit_keywords
      # search everything
      search_term = '%' + keywords.downcase + '%'
      where_term = %{
        (lower(sections.name) LIKE ?
        OR lower(jobs.jce_number) LIKE ?
        OR lower(jobs.job_number) LIKE ?
        OR lower(job_targets.invoice_number) LIKE ?
        OR lower(job_targets.remarks) LIKE ?
        OR lower(job_targets.details) LIKE ?)
      }.gsub(/\s+/, " ").strip

      @job_targets = JobTarget.where(
        where_term,
        search_term,
        search_term,
        search_term,
        search_term,
        search_term,
        search_term
      )
    else
      @job_targets = JobTarget.all
    end

    @job_targets = @job_targets.joins(:section, :job)

    # Then reduce the result set by filtering jobs by dates, filters, etc
    if has_target_start
      @job_targets = @job_targets.where("job_targets.target_date >= ?", target_start_date)
    end
    if has_target_end
      @job_targets = @job_targets.where("job_targets.target_date <= ?", target_end_date)
    end
    unless skip_section_filter
      @job_targets = @job_targets.where(section_id: section_filter_id)
    end

    # Finally, do the ordering and pagination and such
    order_term = "job_targets.target_date desc"
    @job_targets = @job_targets.order(
      order_term
    ).paginate(
      page: page
    ).includes(
      :section, :job
    )

  end
end
