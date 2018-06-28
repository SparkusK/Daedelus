class Invoice < ApplicationRecord
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
end
