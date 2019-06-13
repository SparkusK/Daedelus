class DebtorOrder < ApplicationRecord
  belongs_to :customer
  belongs_to :job, optional: true

  has_many :debtor_payments

  validates :order_number, :value_excluding_tax, :tax_amount,
    :value_excluding_tax, presence: true

  validates :value_excluding_tax, :tax_amount, :value_including_tax,
    numericality: { greater_than_or_equal_to: 0.0 }

  validates :value_excluding_tax, numericality: { less_than: :value_including_tax}
  validates :tax_amount, numericality: { less_than: :value_excluding_tax}

  # Debtor Order -> Debtor Payment

  def self.debtor_payments_count(debtor_order_id)
    DebtorPayment.where("debtor_order_id = ?", debtor_order_id).count(:all)
  end

  def self.removal_confirmation(debtor_order_id)
    count = debtor_payments_count(debtor_order_id)
    confirmation = "Performing this removal will also delete: \n"

    confirmation << "* #{count} Debtor Payment records \n"

    confirmation << "Are you sure?"
  end

  def debtor_order_name
    "#{customer.name}"
  end

  def still_owed_amount
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
  def self.search(keywords, dates, page)

    if keywords.nil?
      where_term = "debtor_orders.updated_at >= ? AND debtor_orders.updated_at <= ?"
      order_term = "customers.name asc, debtor_orders.value_excluding_tax desc"
      DebtorOrder.left_outer_joins(
        :customer, :job
      ).where(
        where_term,
        dates.start_date,
        dates.end_date
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
          AND debtor_orders.updated_at >= ? AND debtor_orders.updated_at <= ?
        }.gsub(/\s+/, " ").strip

        order_term = "customers.email asc"

        DebtorOrder.left_outer_joins(
          :customer, :job
        ).where(
          where_term,
          search_term,
          dates.start_date,
          dates.end_date
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
          OR lower(debtor_orders.order_number) LIKE ?
          AND debtor_orders.updated_at >= ? AND debtor_orders.updated_at <= ?
        }.gsub(/\s+/, " ").strip

        order_term = "debtor_orders.value_excluding_tax desc"

        DebtorOrder.left_outer_joins(
          :customer, :job
        ).where(
          where_term,
          search_term,
          search_term,
          search_term,
          search_term,
          dates.start_date,
          dates.end_date
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
          OR lower(debtor_orders.order_number) LIKE ?
          AND debtor_orders.updated_at >= ? AND debtor_orders.updated_at <= ?
        }.gsub(/\s+/, " ").strip

        order_term = "customers.name asc, debtor_orders.value_excluding_tax desc"

        DebtorOrder.joins(
          :customer
        ).left_outer_joins(
           :job
        ).where(
          where_term,
          search_term,
          search_term,
          search_term,
          search_term,
          search_term,
          search_term,
          dates.start_date,
          dates.end_date
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
