class DebtorPayment < ApplicationRecord
  belongs_to :debtor_order

  def self.search(keywords)

    search_term = '%' + keywords.downcase + '%'

    where_term = %{
      lower(customers.name) LIKE ?
      OR lower(debtor_payments.payment_type) LIKE ?
      OR lower(debtor_payments.note) LIKE ?
    }.gsub(/\s+/, " ").strip

    order_term = "debtor_payments.payment_date desc"

    DebtorPayment.joins(debtor_order: :customer)
    .where(where_term,
       search_term,
       search_term,
       search_term)
    .order(order_term)
  end

end
