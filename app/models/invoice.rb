class Invoice < ApplicationRecord
  has_one :debtor_payment

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
    Invoice.where.not(
      id: DebtorPayment.select("invoice_id").where.not(invoice_id: nil)
    )
  end
end

# .and(
#   CreditorPayment.select("invoice_id").where.not(invoice_id: nil)
# )
