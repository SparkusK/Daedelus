class Job < ApplicationRecord
  validates :targeted_amount, numericality: { less_than_or_equal_to: :total, message: "must be less than or equal to Total" }
  belongs_to :section
  has_many :creditor_orders
  has_many :debtor_orders
  has_many :labor_records

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
  #   sections.name,
  #   jobs.contact_person,
  #   jobs.responsible_person,
  #   jobs.work_description (if " ".count > 1)
  #   quotations.code
  #   jobs.jce_number

  # This search function is really bad. I should rework this thing to make it
  # better somehow, but meh, there's really no incentive at this point
  def self.search(keywords, start_date, end_date, page, show_finished)
    if show_finished.nil?
      show_finished = false
    elsif show_finished == "1" || show_finished == true || show_finished == 1
      show_finished = true
    else
      show_finished = false
    end


    if start_date.nil? || end_date.nil?
      if keywords.nil?
        order_term = "jobs.receive_date desc"
        Job.where(
          "jobs.is_finished = ?", show_finished
        ).order(
          order_term
        ).paginate(
          page: page
        ).includes(
          :section
        )
      elsif keywords =~ /\d/
        search_term = '%' + keywords.downcase + '%'
        where_term = %{
          lower(jobs.jce_number) LIKE ?
          OR lower(jobs.responsible_person) LIKE ?
          OR lower(quotation_reference) LIKE ?
          AND jobs.is_finished = ?
        }.gsub(/\s+/, " ").strip

        order_term = "jobs.receive_date desc"

        Job.where(
          where_term,
          search_term,
          search_term,
          search_term,
          show_finished
        ).order(
          order_term
        ).paginate(
          page: page
        ).includes(
          :section
        )
      else
        # search everything
        search_term = '%' + keywords.downcase + '%'
        where_term = %{
          lower(sections.name) LIKE ?
          OR lower(jobs.contact_person) LIKE ?
          OR lower(jobs.responsible_person) LIKE ?
          OR lower(jobs.work_description) LIKE ?
          OR lower(quotation_reference) LIKE ?
          OR lower(jobs.jce_number) LIKE ?
          AND jobs.is_finished = ?
        }.gsub(/\s+/, " ").strip

        order_term = "jobs.receive_date desc"

        Job.joins(
          :section
        ).where(
          where_term,
          search_term,
          search_term,
          search_term,
          search_term,
          search_term,
          search_term,
          show_finished
        ).order(
          order_term
        ).paginate(
          page: page
        ).includes(
          :section
        )
      end
    else
      if keywords.nil?
        where_term = "target_date >= ? AND target_date <= ? AND jobs.is_finished = ?"
        order_term = "jobs.target_date desc"
        Job.where(
          where_term,
          start_date,
          end_date,
          show_finished
        ).order(
          order_term
        ).paginate(
          page: page
        ).includes(
          :section
        )
      # If there are numbers, we only search:
      #   JCE number, responsible_person, quotation code
      elsif keywords =~ /\d/
        search_term = '%' + keywords.downcase + '%'
        where_term = %{
          lower(jobs.jce_number) LIKE ?
          OR lower(jobs.responsible_person) LIKE ?
          OR lower(quotation_reference) LIKE ?
          AND target_date >= ? AND target_date <= ?
          AND jobs.is_finished = ?
        }.gsub(/\s+/, " ").strip

        order_term = "jobs.receive_date desc"

        Job.where(
          where_term,
          search_term,
          search_term,
          search_term,
          start_date,
          end_date,
          show_finished
        ).order(
          order_term
        ).paginate(
          page: page
        ).includes(
          :section
        )
      else
        # search everything
        search_term = '%' + keywords.downcase + '%'
        where_term = %{
          (lower(sections.name) LIKE ?
          OR lower(jobs.contact_person) LIKE ?
          OR lower(jobs.responsible_person) LIKE ?
          OR lower(jobs.work_description) LIKE ?
          OR lower(quotation_reference) LIKE ?
          OR lower(jobs.jce_number) LIKE ?)
          AND target_date >= ? AND target_date <= ?
          AND jobs.is_finished = ?
        }.gsub(/\s+/, " ").strip

        order_term = "jobs.receive_date desc"

        Job.joins(
          :section
        ).where(
          where_term,
          search_term,
          search_term,
          search_term,
          search_term,
          search_term,
          search_term,
          start_date,
          end_date,
          show_finished
        ).order(
          order_term
        ).paginate(
          page: page
        ).includes(
          :section
        )
      end
    end
  end
end
