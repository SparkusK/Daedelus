class Job < ApplicationRecord
  include Search::Job::TargetComparisonEnum
  include Search::Job::CompletionStatusEnum
  include Searchable
  include RemovalConfirmationBuilder
  belongs_to :section
  has_many :creditor_orders, dependent: :delete_all
  has_many :debtor_orders, dependent: :delete_all
  has_many :labor_records, dependent: :delete_all
  has_many :job_targets, dependent: :delete_all

  validates :receive_date, :contact_person, :responsible_person,
    :work_description, :jce_number, :quotation_reference, :total, :job_number,
    :order_number, :client_section,
      presence: true

  validates :total, numericality: { greater_than: 0.0 }

  def supervisor
    Supervisor.find_by(section_id: section.id)
  end

  def job_name
    job_number.nil? ? "Job number not found" : "#{job_number}"
  end

  def receive_date_string
    receive_date.nil? ? "" : receive_date.strftime("%a, %d %b %Y")
  end

  def targeted_amount
    JobTarget.where(job_id: id).sum(:target_amount)
  end

  def still_available_amount
    total - targeted_amount
  end

  # Job
  #   -> Creditor Order
  #       -> Credit Note
  #   -> Debtor Order
  #       -> Debtor Payment
  #   -> Labor Record
  def self.removal_confirmation(job_id)
    entities = entities(job_id)
    confirmation = "Performing this removal will also delete: \n"

    confirmation << "* #{entities[:creditor_orders].count} Creditor orders \n"
    confirmation << "    * #{entities[:credit_notes].count} Creditor payments \n"
    confirmation << "* #{entities[:debtor_orders].count} Debtor orders \n"
    confirmation << "    * #{entities[:debtor_payments].count} Debtor payments \n"
    confirmation << "* #{entities[:labor_records].count} Labor records \n"
    confirmation << "* #{entities[:job_targets].count} Job targets \n"

    confirmation << "Are you sure?"
  end

  def self.select_tag_amounts_options
    [ ["All", Search::Job::TargetComparisonEnum::ALL],
      ["Not Targeted", Search::Job::TargetComparisonEnum::NOT_TARGETED],
      ["Under Targeted", Search::Job::TargetComparisonEnum::UNDER_TARGETED],
      ["Fully Targeted", Search::Job::TargetComparisonEnum::FULLY_TARGETED],
      ["Over Targeted", Search::Job::TargetComparisonEnum::OVER_TARGETED] ]
  end

  def self.select_tag_completes_options
    [ ["All", Search::Job::CompletionStatusEnum::ALL],
      ["Not Finished", Search::Job::CompletionStatusEnum::NOT_FINISHED],
      ["Finished", Search::Job::CompletionStatusEnum::FINISHED] ]
  end

  private

# ======= SEARCH ========================================

  def self.keyword_search_attributes
    %w{ sections.name jobs.contact_person jobs.responsible_person
    jobs.work_description jobs.quotation_reference jobs.jce_number
    jobs.job_number jobs.order_number jobs.client_section
    jobs.id::varchar(20) }
  end

  def self.subclassed_filters(args)
    filters = []
    filters << Search::Filter::SectionIdFilter.new(args[:section_filter_id])
    filters << Search::Filter::JobTargetedDatesFilter.new(args[:target_dates])
    filters << Search::Filter::DateRangeFilter.new("jobs.receive_date", args[:receive_dates])
    filters << Search::Filter::JobTargetAmountsFilter.new(args[:targets])
    filters << Search::Filter::CompletionStatusFilter.new(args[:completes])
    filters
  end

  def self.subclassed_search_defaults
    {
      target_dates: Utility::DateRange.new(start_date: nil, end_date: nil),
      receive_dates: Utility::DateRange.new(start_date: nil, end_date: nil),
      targets: "All",
      completes: "All",
      section_filter_id: nil
    }
  end

  def self.subclassed_order_term
    "jobs.receive_date desc"
  end

  def self.subclassed_join_list
    :section
  end

  def self.subclassed_includes_list
    :section
  end

  # ---- Get Removal Confirmation stuff ---------------------------------------

  def self.creditor_orders(job_id)
    CreditorOrder.where("job_id = ?", job_id)
  end

  def self.credit_notes(creditor_order_ids)
    CreditNote.where("creditor_order_id IN (?)", creditor_order_ids)
  end

  def self.debtor_orders(job_id)
    DebtorOrder.where("job_id = ?", job_id)
  end

  def self.debtor_payments(debtor_order_ids)
    DebtorPayment.where("debtor_order_id IN (?)", debtor_order_ids)
  end

  def self.job_labor_records(job_id)
    LaborRecord.where("job_id = ?", job_id)
  end

  def self.job_targets(job_id)
    JobTarget.where("job_id = ?", job_id)
  end

  def self.entities(job_id)
    creditor_orders  = creditor_orders(   job_id              )
    credit_notes     = credit_notes(      creditor_orders.ids )
    debtor_orders    = debtor_orders(     job_id              )
    debtor_payments  = debtor_payments(   debtor_orders.ids   )
    labor_records    = job_labor_records( job_id              )
    job_targets      = job_targets(       job_id              )
    {
      creditor_orders: creditor_orders,
      credit_notes: credit_notes,
      debtor_orders: debtor_orders,
      debtor_payments: debtor_payments,
      labor_records: labor_records,
      job_targets: job_targets
    }
  end
end
