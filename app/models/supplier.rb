class Supplier < ApplicationRecord

  has_many :creditor_orders


  def supplier_name
    "#{name}"
  end

  def get_removal_confirmation
    confirmation = "Performing this removal will also delete: \n"
    confirmation << "* #{self.creditor_orders.count} Creditor Order records, including: \n" unless self.creditor_orders.nil?
    creditor_orders_payments_total = 0
    self.creditor_orders.each do |creditor_order|
      creditor_orders_payments_total += creditor_order.credit_notes.count unless creditor_order.credit_notes.nil?
    end
    confirmation << "  * #{creditor_orders_payments_total} Creditor Payments from Creditor Orders \n"
    confirmation << "Are you sure?"
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
