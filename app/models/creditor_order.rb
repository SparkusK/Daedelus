class CreditorOrder < ApplicationRecord
  belongs_to :supplier
  belongs_to :job
  belongs_to :invoice

  def creditor_order_name
    "Supplier #{supplier.name}, job #{job.jce_number}"
  end

  # Search by supplier.name, invoice.code
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
