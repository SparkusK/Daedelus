class CreditNote < ApplicationRecord
  belongs_to :creditor_order

  # Search by creditor_order.job.jce_number,
  #           creditor_order.supplier.name,
  #           payment_type
  def fuzzy_search(params)
    # if params contains numbers
      # search phone
    # else
      # search the rest
    # end

  end

  def self.search(keywords)

    search_term = keywords.downcase + '%'

    where_term = %{
      lower(first_name) LIKE ?
      OR lower(last_name) LIKE ?
    }.gsub(/\s+/, " ").strip

    order_term = "last_name asc"

    Employee.where(where_term, search_term, search_term).order(order_term)
  end
end
