class CreditNote < ApplicationRecord
  belongs_to :creditor_order
  belongs_to :invoice

  def self.search(keywords)

    search_term = '%' + keywords.downcase + '%'

    where_term = %{
      lower(suppliers.name) LIKE ?
      OR lower(credit_notes.payment_type) LIKE ?
      OR lower(credit_notes.note) LIKE ?
      OR lower(jobs.jce_number) LIKE ?
      OR lower(invoices.code) LIKE ?
    }.gsub(/\s+/, " ").strip

    order_term = "credit_notes.updated_at desc"

    CreditNote.joins(:invoice, creditor_order: [:job, :supplier] )
    .where(where_term,
       search_term,
       search_term,
       search_term,
       search_term,
       search_term)
    .order(order_term)
  end


end
