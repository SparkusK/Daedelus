class DebtorOrder < ApplicationRecord
  belongs_to :customer
  belongs_to :job, optional: true
  belongs_to :invoice

  def debtor_order_name
    "Customer #{customer.name}"
  end

  # Search by customer.name, invoice.code, or SA_number
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
