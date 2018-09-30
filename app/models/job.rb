class Job < ApplicationRecord
  validates :targeted_amount, numericality: { less_than_or_equal_to: :total, message: "must be less than or equal to Total" }
  belongs_to :section
  has_many :creditor_orders
  has_many :labor_records

  def get_supervisor
    Supervisor.find_by(section_id: section.id)
  end

  def job_name
    "#{jce_number}"
  end

  def still_available_amount
    self.total - self.targeted_amount
  end

  # Search by:
  #   sections.name,
  #   jobs.contact_person,
  #   jobs.responsible_person,
  #   jobs.work_description (if " ".count > 1)
  #   quotations.code
  #   jobs.jce_number
  def self.search(keywords)

    search_term = '%' + keywords.downcase + '%'

    # If there are numbers, we only search:
    #   JCE number, responsible_person, quotation code
    if keywords =~ /\d/
      where_term = %{
        lower(jobs.jce_number) LIKE ?
        OR lower(jobs.responsible_person) LIKE ?
        OR lower(quotation_reference) LIKE ?
      }.gsub(/\s+/, " ").strip

      order_term = "jobs.receive_date desc"

      Job.where(
        where_term,
        search_term,
        search_term,
        search_term
      ).order(order_term)
    else
      # search everything
      where_term = %{
        lower(sections.name) LIKE ?
        OR lower(jobs.contact_person) LIKE ?
        OR lower(jobs.responsible_person) LIKE ?
        OR lower(jobs.work_description) LIKE ?
        OR lower(quotation_reference) LIKE ?
        OR lower(jobs.jce_number) LIKE ?
      }.gsub(/\s+/, " ").strip

      order_term = "jobs.receive_date desc"

      Job.joins(:section)
      .where(
        where_term,
        search_term,
        search_term,
        search_term,
        search_term,
        search_term,
        search_term
      ).order(order_term)
    end
  end
end
