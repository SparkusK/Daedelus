class Job < ApplicationRecord
  belongs_to :section
  belongs_to :debtor_order
  belongs_to :quotation
  has_many :labor_records

  def get_supervisor
    Supervisor.find_by(section_id: section.id)
  end

  def job_name
    "Job no. #{jce_number}"
  end

  # Search by:
  #   sections.name,
  #   jobs.contact_person,
  #   jobs.balow_section,
  #   jobs.work_description (if " ".count > 1)
  #   debtor_orders.customer.name
  #   quotations.code
  #   jobs.jce_number
  def self.search(keywords)

    search_term = '%' + keywords.downcase + '%'

    # If there are numbers, we only search:
    #   JCE number, balow section, quotation code
    if keywords =~ /\d/
      where_term = %{
        lower(jobs.jce_number) LIKE ?
        OR lower(jobs.balow_section) LIKE ?
        OR lower(quotations.code) LIKE ?
      }.gsub(/\s+/, " ").strip

      order_term = "jobs.receive_date desc"

      Job.joins(:quotation)
      .where(
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
        OR lower(jobs.balow_section) LIKE ?
        OR lower(jobs.work_description) LIKE ?
        OR lower(customers.name) LIKE ?
        OR lower(quotations.code) LIKE ?
        OR lower(jobs.jce_number) LIKE ?
      }.gsub(/\s+/, " ").strip

      order_term = "jobs.receive_date desc"

      Job.joins(:section, :quotation, debtor_order: :customer)
      .where(
        where_term,
        search_term,
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
