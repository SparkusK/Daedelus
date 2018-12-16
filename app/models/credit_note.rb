class CreditNote < ApplicationRecord
  belongs_to :creditor_order
  validates_each :amount_paid do |record, attr, value|
    record.errors.add(attr, "Can't pay more than is still owed") if
      value > record.creditor_order.get_still_owed_amount
    end

  validates :invoice_code, :amount_paid, :payment_type, :note, presence: true

  def self.search(keywords, start_date, end_date, page)

    if keywords.nil?

      where_term = "credit_notes.updated_at >= ? AND credit_notes.updated_at <= ?"

      order_term = "credit_notes.amount_paid desc"

      CreditNote.joins(
        creditor_order: [:job, :supplier]
      ).where(
        where_term,
        start_date,
        end_date
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
        OR lower(credit_notes.payment_type) LIKE ?
        OR lower(credit_notes.note) LIKE ?
        OR lower(jobs.jce_number) LIKE ?
        AND credit_notes.updated_at >= ? AND credit_notes.updated_at <= ?
      }.gsub(/\s+/, " ").strip

      order_term = "credit_notes.updated_at desc"

      CreditNote.joins(
        creditor_order: [:job, :supplier]
      ).where(
        where_term,
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
        creditor_order: [:supplier, :job]
      )

    end
  end


end
