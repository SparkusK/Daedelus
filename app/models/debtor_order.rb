class DebtorOrder < ApplicationRecord
  belongs_to :customer
  belongs_to :job, optional: true

  def debtor_order_name
    "#{order_number.upcase} \t(#{customer.name})"
  end

  def get_value_excluding_tax
    value = self.value_excluding_tax
    # Sum all payment amounts of debtor payments with debtor_order_id = self.id
    paid = DebtorPayment.where(debtor_order_id: self.id).sum(:payment_amount)
    still_owed = value - paid
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
  def self.search(keywords, start_date, end_date, page)

    if keywords.nil?
      where_term = "debtor_orders.updated_at > ? AND debtor_orders.updated_at < ?"
      order_term = "customers.name asc, debtor_orders.value_excluding_tax desc"
      DebtorOrder.left_outer_joins(
        :customer, :job
      ).where(
        where_term,
        start_date,
        end_date
      ).order(
        order_term
      ).paginate(
        page: page
      ).includes(
        :customer
      )
    else
      is_email = !(( keywords =~ /@|\./ ).nil?)
      has_numbers = !(( keywords =~ /\d/ ).nil?)

      search_term = '%' + keywords.downcase + '%'

      if is_email
        where_term = %{
          lower(customers.email) LIKE ?
          AND debtor_orders.updated_at > ? AND debtor_orders.updated_at < ?
        }.gsub(/\s+/, " ").strip

        order_term = "customers.email asc"

        DebtorOrder.left_outer_joins(
          :customer, :job
        ).where(
          where_term,
          search_term,
          start_date,
          end_date
        ).order(
          order_term
        ).paginate(
          page: page
        ).includes(
          :customer
        )

      elsif has_numbers
        where_term = %{
          lower(customers.email) LIKE ?
          OR customers.phone LIKE ?
          OR lower(jobs.jce_number) LIKE ?
          AND debtor_orders.updated_at > ? AND debtor_orders.updated_at < ?
        }.gsub(/\s+/, " ").strip

        order_term = "debtor_orders.value_excluding_tax desc"

        DebtorOrder.left_outer_joins(
          :customer, :job
        ).where(
          where_term,
          search_term,
          search_term,
          search_term,
          start_date,
          end_date
        ).order(
          order_term
        ).paginate(
          page: page
        ).includes(
          :customer
        )
      else
        where_term = %{
          lower(customers.name) LIKE ?
          OR lower(customers.email) LIKE ?
          OR lower(jobs.jce_number) LIKE ?
          OR lower(jobs.contact_person) LIKE ?
          OR lower(jobs.responsible_person) LIKE ?
          AND debtor_orders.updated_at > ? AND debtor_orders.updated_at < ?
        }.gsub(/\s+/, " ").strip

        order_term = "customers.name asc, debtor_orders.value_excluding_tax desc"

        DebtorOrder.left_outer_joins(
          :customer, :job
        ).where(
          where_term,
          search_term,
          search_term,
          search_term,
          search_term,
          search_term,
          start_date,
          end_date
        ).order(
          order_term
        ).paginate(
          page: page
        ).includes(
          :customer
        )
      end
    end
  end
end
