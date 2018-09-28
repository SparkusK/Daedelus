class CreditNote < ApplicationRecord
  belongs_to :creditor_order
  validates_each :amount_paid do |record, attr, value|
    record.errors.add(attr, "Can't pay more than is still owed") if
      value > record.creditor_order.get_still_owed_amount
    end

  def self.search(keywords)

    search_term = '%' + keywords.downcase + '%'

    where_term = %{
      lower(suppliers.name) LIKE ?
      OR lower(credit_notes.payment_type) LIKE ?
      OR lower(credit_notes.note) LIKE ?
      OR lower(jobs.jce_number) LIKE ?
    }.gsub(/\s+/, " ").strip

    order_term = "credit_notes.updated_at desc"

    CreditNote.joins(creditor_order: [:job, :supplier] )
    .where(where_term,
       search_term,
       search_term,
       search_term,
       search_term)
    .order(order_term)
  end


end
