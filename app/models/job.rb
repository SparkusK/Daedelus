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

end
