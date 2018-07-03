class CreditorOrder < ApplicationRecord
  belongs_to :supplier
  belongs_to :job
  belongs_to :invoice

  def creditor_order_name
    "Supplier #{supplier.name}, job #{job.jce_number}"
  end
  # Search by:
  #   supplier:
  #     * name
  #     * email
  #     * phone
  #   Job:
  #     * JCE number
  #     * contact person
  #     * balow_section
  #   Invoice:
  #     * Invoice code
  def self.search(keywords)

    is_email = !(( keywords =~ /@|\./ ).nil?)
    has_numbers = !(( keywords =~ /\d/ ).nil?)


    search_term = '%' + keywords.downcase + '%'

    if is_email
      where_term = %{
        lower(suppliers.email) LIKE ?
      }.gsub(/\s+/, " ").strip

      order_term = "suppliers.email asc"

      CreditorOrder.joins(:supplier, :invoice, :job)
      .where(where_term,
        search_term)
      .order(order_term)

    elsif has_numbers
      where_term = %{
        lower(suppliers.email) LIKE ?
        OR suppliers.phone LIKE ?
        OR lower(jobs.jce_number) LIKE ?
        OR lower(invoices.code) LIKE ?
      }.gsub(/\s+/, " ").strip

      order_term = "creditor_orders.still_owed_amount desc"

      CreditorOrder.joins(:supplier, :invoice, :job)
      .where(where_term,
        search_term,
        search_term,
        search_term,
        search_term)
      .order(order_term)
    else
      where_term = %{
        lower(suppliers.name) LIKE ?
        OR lower(suppliers.email) LIKE ?
        OR lower(jobs.jce_number) LIKE ?
        OR lower(jobs.contact_person) LIKE ?
        OR lower(jobs.balow_section) LIKE ?
        OR lower(invoices.code) LIKE ?
      }.gsub(/\s+/, " ").strip

      order_term = "suppliers.name asc, creditor_orders.still_owed_amount desc"

      CreditorOrder.joins(:supplier, :invoice, :job)
      .where(where_term,
        search_term,
        search_term,
        search_term,
        search_term,
        search_term,
        search_term)
      .order(order_term)
    end
  end
end
