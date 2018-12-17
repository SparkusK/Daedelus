class Job < ApplicationRecord
  validates :targeted_amount, numericality: { less_than_or_equal_to: :total, message: "must be less than or equal to Total" }
  belongs_to :section
  has_many :creditor_orders
  has_many :debtor_orders
  has_many :labor_records

  validates :receive_date, :target_date,
    :contact_person, :responsible_person, :work_description, :jce_number,
    :quotation_reference, :total, :targeted_amount,
    presence: true

  validates :total, numericality: { greater_than: 0.0 }
  validates :targeted_amount, numericality: { greater_than_or_equal_to: 0.0 }
  validates :targeted_amount, numericality: { less_than_or_equal_to: :total }

  def get_supervisor
    Supervisor.find_by(section_id: section.id)
  end

  def job_name
    "#{jce_number}"
  end

  def get_receive_date_string
    self.receive_date.nil? ? "" : self.receive_date.strftime("%a, %d %b %Y")
  end

  def still_available_amount
    self.total - self.targeted_amount
  end

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

  def self.get_entities(job_id)
    creditor_orders  = get_creditor_orders(   job_id              )
    credit_notes     = get_credit_notes(      creditor_orders.ids )
    debtor_orders    = get_debtor_orders(     job_id              )
    debtor_payments  = get_debtor_payments(   debtor_orders.ids   )
    labor_records    = get_job_labor_records( job_id              )
    {
      creditor_orders: creditor_orders,
      credit_notes: credit_notes,
      debtor_orders: debtor_orders,
      debtor_payments: debtor_payments,
      labor_records: labor_records
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

    confirmation << "Are you sure?"
  end

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
    page, targets, completes
  )

    # Let's first setup some named conditions on which we want to search
    has_target_start = !target_start_date.nil? && !target_start_date.empty?
    has_target_end = !target_end_date.nil? && !target_end_date.empty?
    has_receive_start = !receive_start_date.nil? && !receive_start_date.empty?
    has_receive_end = !receive_end_date.nil? && !receive_end_date.empty?
    omit_keywords = keywords.nil? || keywords.empty?

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
        OR jobs.id::varchar(20) LIKE ?)
      }.gsub(/\s+/, " ").strip

      @jobs = Job.where(
        where_term,
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
    if has_target_start
      @jobs = @jobs.where("jobs.target_date >= ?", target_start_date)
    end
    if has_target_end
      @jobs = @jobs.where("jobs.target_date <= ?", target_end_date)
    end
    if has_receive_start
      @jobs = @jobs.where("jobs.receive_date >= ?", receive_start_date)
    end
    if has_receive_end
      @jobs = @jobs.where("jobs.receive_date <= ?", receive_end_date)
    end

    case targets
    when "All"
      # we don't really need to do anything here
    when "Not targeted"
      # Jobs where targeted_amount = 0
      @jobs = @jobs.where("jobs.targeted_amount = 0")
    when "Partially targeted"
      # Jobs where 0 < targeted_amount < total
      @jobs = @jobs.where("jobs.targeted_amount > 0 AND jobs.targeted_amount < jobs.total")
    when "Fully targeted"
      # Jobs where targeted_amount >= total
      @jobs = @jobs.where("jobs.targeted_amount >= jobs.total")
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
