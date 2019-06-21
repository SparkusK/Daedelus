class CreditorPayment < ApplicationRecord
  belongs_to :creditor_order
  validates_each :amount_paid do |record, attr, value|
    record.errors.add(attr, "Can't pay more than is still owed") if
      value > record.creditor_order.still_owed_amount
  end

  validates :amount_paid, numericality: { greater_than_or_equal_to: 0.0 }

  validates :invoice_code, :amount_paid, :payment_type, :note, presence: true

  def self.search(keywords, dates, page)

    if keywords.nil?

      where_term = "creditor_payments.updated_at >= ? AND creditor_payments.updated_at <= ?"

      order_term = "creditor_payments.amount_paid desc"

      CreditorPayment.joins(
        creditor_order: [:job, :supplier]
      ).where(
        where_term,
        dates.start_date,
        dates.end_date
      ).order(
        order_term
      ).paginate(
        page: page
      ).includes(
        creditor_order: [:supplier, :job]
      )

    else

      search_term = '%' + keywords.downcase + '%'

      where_term = %{
        lower(suppliers.name) LIKE ?
        OR lower(creditor_payments.payment_type) LIKE ?
        OR lower(creditor_payments.note) LIKE ?
        OR lower(jobs.jce_number) LIKE ?
        AND creditor_payments.updated_at >= ? AND creditor_payments.updated_at <= ?
      }.gsub(/\s+/, " ").strip

      order_term = "creditor_payments.updated_at desc"

      CreditorPayment.joins(
        creditor_order: [:job, :supplier]
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
        creditor_order: [:supplier, :job]
      )

    end
  end


end
