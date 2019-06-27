class JobTarget < ApplicationRecord
  include Searchable
  belongs_to :section
  belongs_to :job

  validates :target_date, :invoice_number, :target_amount, presence: true

  validates :target_amount, numericality: { greater_than: 0.0 }

  def available_amount
    total = self.job.total
    payments = JobTarget.where(job_id: self.job_id).sum(:target_amount)
    total - payments
  end

  def removal_confirmation(job_target_id)
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
  def amounts(job_id)
    job_total = self.job.total
    payments = JobTarget
      .where(job_id: job_id)
      .where.not(id: self.id)
      .sum(:target_amount)
    remaining_amount = job_total - payments
    amounts = {remaining_amount: remaining_amount, job_total: job_total}
  end

  def self.amounts_for_new_job_target(job_id)
    job_total = Job.find_by(id: job_id).total
    payments = JobTarget.where(job_id: job_id).sum(:target_amount)
    remaining_amount = job_total - payments
    amounts = {remaining_amount: remaining_amount, job_total: job_total}
  end

  private

# ======= SEARCH ========================================

  def self.keyword_search_attributes
    %w{ sections.name jobs.jce_number jobs.job_number job_targets.invoice_number
       job_targets.remarks job_targets.details }
  end

  def self.subclassed_filters(args)
    filters = []
    filters << Search::Filter::SectionIdFilter.new(args[:section_filter_id])
    filters << Search::Filter::DateRangeFilter.new("job_targets.target_date", args[:target_dates])
    filters
  end

  def self.subclassed_search_defaults
    { target_dates: Utility::DateRange.new(start_date: nil, end_date: nil),
      section_filter_id: nil }
  end

  def self.subclassed_order_term
    "job_targets.target_date desc"
  end

  def self.subclassed_join_list
    [ :section, :job ]
  end

  def self.subclassed_includes_list
    [ :section, :job ]
  end
end
