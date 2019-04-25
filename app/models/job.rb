class Job < ApplicationRecord
  belongs_to :section
  has_many :creditor_orders
  has_many :debtor_orders
  has_many :labor_records
  has_many :job_targets

  validates :receive_date, :contact_person, :responsible_person,
    :work_description, :jce_number, :quotation_reference, :total, :job_number,
    :order_number, :client_section,
      presence: true

  validates :total, numericality: { greater_than: 0.0 }

  def get_supervisor
    Supervisor.find_by(section_id: section.id)
  end

  def job_name
    job_number.nil? ? "Job number not found" : "#{job_number}"
  end

  def get_receive_date_string
    self.receive_date.nil? ? "" : self.receive_date.strftime("%a, %d %b %Y")
  end

  def targeted_amount
    JobTarget.where(job_id: self.id).sum(:target_amount)
  end

  def still_available_amount
    self.total - self.targeted_amount
  end

  def self.get_amount_remaining(job)
    job.total - JobTarget.where(job_id: job.id).sum(target_amount)
  end

  # ---- Get Removal Confirmation stuff ---------------------------------------

  def self.get_creditor_orders(job_id)
    CreditorOrder.where("job_id = ?", job_id)
  end

  def self.get_credit_notes(creditor_order_ids)
    CreditNote.where("creditor_order_id IN (?)", creditor_order_ids)
  end

  def self.get_debtor_orders(job_id)
    DebtorOrder.where("job_id = ?", job_id)
  end

  def self.get_debtor_payments(debtor_order_ids)
    DebtorPayment.where("debtor_order_id IN (?)", debtor_order_ids)
  end

  def self.get_job_labor_records(job_id)
    LaborRecord.where("job_id = ?", job_id)
  end

  def self.get_job_targets(job_id)
    JobTarget.where("job_id = ?", job_id)
  end

  def self.get_entities(job_id)
    creditor_orders  = get_creditor_orders(   job_id              )
    credit_notes     = get_credit_notes(      creditor_orders.ids )
    debtor_orders    = get_debtor_orders(     job_id              )
    debtor_payments  = get_debtor_payments(   debtor_orders.ids   )
    labor_records    = get_job_labor_records( job_id              )
    job_targets      = get_job_targets(       job_id              )
    {
      creditor_orders: creditor_orders,
      credit_notes: credit_notes,
      debtor_orders: debtor_orders,
      debtor_payments: debtor_payments,
      labor_records: labor_records,
      job_targets: job_targets
    }
  end

  # Job
  #   -> Creditor Order
  #       -> Credit Note
  #   -> Debtor Order
  #       -> Debtor Payment
  #   -> Labor Record
  def self.get_removal_confirmation(job_id)
    entities = get_entities(job_id)
    confirmation = "Performing this removal will also delete: \n"

    confirmation << "* #{entities[:creditor_orders].count} Creditor Order records \n"
    confirmation << "    * #{entities[:credit_notes].count} Creditor Payment records \n"
    confirmation << "* #{entities[:debtor_orders].count} Debtor Order records \n"
    confirmation << "    * #{entities[:debtor_payments].count} Debtor Payment records \n"
    confirmation << "* #{entities[:labor_records].count} Labor Records \n"
    confirmation << "* #{entities[:job_targets].count} Job Target records \n"

    confirmation << "Are you sure?"
  end

# ------------------------------------------------------------------------------

  # Search by:
  # If there are NO keywords:
  #   Grab everything
  #
  # If there are keywords:
  #   jobs.id,
  #   sections.name,
  #   jobs.contact_person,
  #   jobs.responsible_person,
  #   jobs.work_description
  #   jobs.quotation_reference
  #   jobs.jce_number
  #
  #
  # If there's a start date:
  #   all the above, only those after the start date
  # If there's an end date:
  #   All the above, only jobs before the end date
  #
  # If there are both dates:
  #   All the above, only jobs between start and end date
  #
  # And then a bunch of cases depending on which target and completion statuses
  # were selected.
  #
  def self.search(
    keywords,
    target_start_date, target_end_date,
    receive_start_date, receive_end_date,
    page, targets, completes, section_filter_id
  )

    # Let's first setup some named conditions on which we want to search
    has_target_start = !target_start_date.nil? && !target_start_date.empty?
    has_target_end = !target_end_date.nil? && !target_end_date.empty?
    has_receive_start = !receive_start_date.nil? && !receive_start_date.empty?
    has_receive_end = !receive_end_date.nil? && !receive_end_date.empty?
    omit_keywords = keywords.nil? || keywords.empty?
    skip_section_filter = section_filter_id.nil? || section_filter_id.empty?

    @jobs = nil # Initialize @jobs so we don't get NilError


    # Start by grabbing everything we need according to the search keywords
    unless omit_keywords
      # search everything
      search_term = '%' + keywords.downcase + '%'
      where_term = %{
        (lower(sections.name) LIKE ?
        OR lower(jobs.contact_person) LIKE ?
        OR lower(jobs.responsible_person) LIKE ?
        OR lower(jobs.work_description) LIKE ?
        OR lower(quotation_reference) LIKE ?
        OR lower(jobs.jce_number) LIKE ?
        OR jobs.id::varchar(20) LIKE ?
        OR lower(jobs.job_number) LIKE ?
        OR lower(jobs.order_number) LIKE ?
        OR lower(jobs.client_section) LIKE ?)
      }.gsub(/\s+/, " ").strip

      @jobs = Job.where(
        where_term,
        search_term,
        search_term,
        search_term,
        search_term,
        search_term,
        search_term,
        search_term,
        search_term,
        search_term,
        search_term
      )
    else
      @jobs = Job.all
    end
    @jobs = @jobs.joins(:section)

    # Then reduce the result set by filtering jobs by dates, filters, etc
    case targets
    when "All"
      # we don't really need to do anything here
    when "Not targeted"
      # Jobs where targeted_amount = 0
      @jobs = @jobs.where(id: get_not_targeted_records(@jobs))
    when "Under Targeted"
      # Jobs where targeted_amount < job.total
      @jobs = @jobs.where(id: get_targeted_records('<'))
    when "Fully Targeted"
      # Jobs where targeted_amount == total
      @jobs = @jobs.where(id: get_targeted_records('='))
    when "Over Targeted"
      # Jobs where targeted_amount > job.total
      @jobs = @jobs.where(id: get_targeted_records('>'))
    end

    case completes
    when "All"
      # we also don't need to do anything here
    when "Not finished"
      # jobs where is_finished is false
      @jobs = @jobs.where("jobs.is_finished = 'f'")
    when "Finished"
      # jobs where is_finished is true
      @jobs = @jobs.where("jobs.is_finished = 't'")
    end

    if has_target_start
      # Jobs for which their earliest Job Target's Date is after the input date
      @jobs = @jobs.where(id: get_target_date_jobs(true, target_start_date))
    end
    if has_target_end
      # Jobs for which their latest Job Target's Date is before the Input Date
      @jobs = @jobs.where(id: get_target_date_jobs(false, target_end_date))
    end
    if has_receive_start
      @jobs = @jobs.where("jobs.receive_date >= ?", receive_start_date)
    end
    if has_receive_end
      @jobs = @jobs.where("jobs.receive_date <= ?", receive_end_date)
    end
    unless skip_section_filter
      @jobs = @jobs.where(section_id: section_filter_id)
    end


    # Finally, do the ordering and pagination and such
    order_term = "jobs.receive_date desc"
    @jobs = @jobs.order(
      order_term
    ).paginate(
      page: page
    ).includes(
      :section
    )
  end
end

def get_targeted_records(modifier)
  raise "Only valid modifiers are allowed." if !(['<', '>', '='].include? modifier)
  sql = "SELECT jobs.id, jobs.total, SUM(job_targets.target_amount)
  FROM jobs LEFT OUTER JOIN job_targets
  ON job_targets.job_id = jobs.id
  GROUP BY jobs.id
  HAVING SUM(job_targets.target_amount) #{modifier} jobs.total;"
  results = ActiveRecord::Base.connection.execute(sql)
  ids = results.map{|hash| hash["id"]}
end

def get_not_targeted_records
  sql = "SELECT jobs.id, jobs.total, SUM(job_targets.target_amount)
  FROM jobs LEFT OUTER JOIN job_targets
  ON job_targets.job_id = jobs.id
  GROUP BY jobs.id
  HAVING SUM(job_targets.target_amount) IS NULL;"
  results = ActiveRecord::Base.connection.execute(sql)
  ids = results.map{|hash| hash["id"]}
end


def get_target_date_jobs(start, input_date)

  # I don't know which types of formats, other than the regex listed below,
  # Postgres actually supports. I know that the Javascript Calendar datepicker
  # actually outputs to this format too. So, any weird input behaviors should
  # be caught by both the following regex and the Date.parse() method in the
  # begin..rescue block.
  input_date_format_valid = !(/\A\d{4}-\d{2}-\d{2}\z/ =~ input_date).nil?
  if input_date_format_valid
    begin
      # This will make sure that the input date actually parses to a valid date
      Date.parse(input_date)
    rescue ArgumentError
      raise "Input date needs to be a valid date ('YYYY-MM-DD'). [PARSE_ERROR]"
    end
  else
    raise "Input date needs to be a valid date ('YYYY-MM-DD'). [FORMAT_INVALID]"
  end
  # If we got to this point, we can assume input_date is mostly good.
  # We need to make sure it's good, because we're taking data directly from the
  # UI. SQL Injections and such.

  if start
    comparator = '>='
    date_order = 'ASC'
  else
    comparator = '<='
    date_order = 'DESC'
  end

  sql = "SELECT DISTINCT ON (jobs.id) job_id, job_targets.target_date
  FROM jobs
  INNER JOIN job_targets ON job_targets.job_id = jobs.id
  WHERE target_date #{comparator} '#{input_date}'
  ORDER BY jobs.id ASC, job_targets.target_date #{date_order};"
  results = ActiveRecord::Base.connection.execute(sql)
  ids = results.map{|hash| hash["job_id"]}
end

(/\A\d{4}-\d{2}-\d{2}\z/ =~ "2019-03-25").nil?


# SELECT jobs.id, jobs.total, SUM(job_targets.target_amount)
# FROM jobs LEFT OUTER JOIN job_targets
# ON job_targets.job_id = jobs.id
# GROUP BY jobs.id
# HAVING jobs.total < SUM(job_targets.target_amount);

# TARGET_START_DATE
# SELECT DISTINCT ON (jobs.id) job_id, job_targets.target_date
# FROM jobs
# INNER JOIN job_targets ON job_targets.job_id = jobs.id
# WHERE target_date >= '2019-03-15'
# ORDER BY jobs.id ASC, job_targets.target_date ASC;

# TARGET_END_DATE
# SELECT DISTINCT ON (jobs.id) job_id, job_targets.target_date
# FROM jobs
# INNER JOIN job_targets ON job_targets.job_id = jobs.id
# WHERE target_date <= '2019-02-15'
# ORDER BY jobs.id ASC, job_targets.target_date DESC;
