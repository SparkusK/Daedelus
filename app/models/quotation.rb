class Quotation < ApplicationRecord
  has_many :jobs

  def quotation_code
    "#{code}"
  end

  def self.search(keywords)

    search_term = '%' + keywords.downcase + '%'

    where_term = %{
      lower(code) LIKE ?
    }.gsub(/\s+/, " ").strip

    order_term = "code asc"

    Quotation.where(where_term, search_term).order(order_term)
  end
end
