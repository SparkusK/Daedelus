class Invoice < ApplicationRecord
  has_one :debtor_payment
  has_one :creditor_payment

  def invoice_code
    "#{code}"
  end

  def self.search(keywords)

    search_term = '%' + keywords.downcase + '%'

    where_term = %{
      lower(code) LIKE ?
    }.gsub(/\s+/, " ").strip

    order_term = "code asc"

    Invoice.where(where_term, search_term).order(order_term)
  end

  def self.unused
    query = "SELECT * FROM invoices WHERE id NOT IN (
      SELECT DISTINCT invoice_id FROM (
        SELECT invoice_id FROM credit_notes
          UNION
        SELECT invoice_id FROM debtor_payments
      ) AS used_invoices WHERE invoice_id IS NOT NULL
    );"
    Invoice.find_by_sql(query)
  end

end
