class Supplier < ApplicationRecord
  def supplier_name
    "#{name}"
  end

  def self.search(keywords)

    search_term = '%' + keywords.downcase + '%'

    if keywords =~ /\d/
      # search only phone
      where_term = %{
        phone LIKE ?
      }.gsub(/\s+/, " ").strip
      order_term = "phone asc"
      Supplier.where(where_term, search_term).order(order_term)
    elsif keywords.include?("@")
      # search only email
      where_term = %{
        lower(email) LIKE ?
      }.gsub(/\s+/, " ").strip
      order_term = "email asc"
      Supplier.where(where_term, search_term).order(order_term)
    else
      # search everything
      where_term = %{
        phone LIKE ?
        OR lower(email) LIKE ?
        OR lower(name) LIKE ?
      }.gsub(/\s+/, " ").strip
      order_term = "name asc"
      Supplier.where(where_term, search_term, search_term, search_term).order(order_term)
    end
  end
end
