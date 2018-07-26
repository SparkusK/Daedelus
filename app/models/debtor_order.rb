class DebtorOrder < ApplicationRecord
  belongs_to :customer
  belongs_to :job, optional: true

  def debtor_order_name
    "Customer #{customer.name}"
  end

  # Search by:
  #   Customer:
  #     * name
  #     * email
  #     * phone
  #   Job:
  #     * JCE number
  #     * contact person
  #     * responsible_person
  #   Invoice:
  # => *** This changed! We're moving Invoice to the Debtor Payments now.
  def self.search(keywords)

    is_email = !(( keywords =~ /@|\./ ).nil?)
    has_numbers = !(( keywords =~ /\d/ ).nil?)


    search_term = '%' + keywords.downcase + '%'

    if is_email
      where_term = %{
        lower(customers.email) LIKE ?
      }.gsub(/\s+/, " ").strip

      order_term = "customers.email asc"

      DebtorOrder.left_outer_joins(:customer, :job)
      .where(where_term,
        search_term)
      .order(order_term)

    elsif has_numbers
      where_term = %{
        lower(customers.email) LIKE ?
        OR customers.phone LIKE ?
        OR lower(jobs.jce_number) LIKE ?
      }.gsub(/\s+/, " ").strip

      order_term = "debtor_orders.still_owed_amount desc"

      DebtorOrder.left_outer_joins(:customer, :job)
      .where(where_term,
        search_term,
        search_term,
        search_term)
      .order(order_term)
    else
      where_term = %{
        lower(customers.name) LIKE ?
        OR lower(customers.email) LIKE ?
        OR lower(jobs.jce_number) LIKE ?
        OR lower(jobs.contact_person) LIKE ?
        OR lower(jobs.responsible_person) LIKE ?
      }.gsub(/\s+/, " ").strip

      order_term = "customers.name asc, debtor_orders.still_owed_amount desc"

      DebtorOrder.left_outer_joins( :customer, :invoice, :job)
      .where(where_term,
        search_term,
        search_term,
        search_term,
        search_term,
        search_term)
      .order(order_term)
    end

  end
end
