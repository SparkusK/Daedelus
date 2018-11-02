class Customer < ApplicationRecord

  has_many :debtor_orders

  def customer_name
    "#{name}"
  end

  def get_removal_confirmation
    confirmation = "Performing this removal will also delete: \n"
    confirmation << "* #{self.debtor_orders.count} Debtor Order records, including: \n" unless self.debtor_orders.nil?
    debtor_orders_payments_total = 0
    self.debtor_orders.each do |debtor_order|
      debtor_orders_payments_total += debtor_order.debtor_payments.count unless debtor_order.debtor_payments.nil?
    end
    confirmation << "  * #{debtor_orders_payments_total} Debtor Payments from Debtor Orders \n" 
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
      Customer.where(where_term, search_term).order(order_term)
    elsif keywords.include?("@")
      # search only email
      where_term = %{
        lower(email) LIKE ?
      }.gsub(/\s+/, " ").strip
      order_term = "email asc"
      Customer.where(where_term, search_term).order(order_term)
    else
      # search everything
      where_term = %{
        phone LIKE ?
        OR lower(email) LIKE ?
        OR lower(name) LIKE ?
      }.gsub(/\s+/, " ").strip
      order_term = "name asc"
      Customer.where(where_term, search_term, search_term, search_term).order(order_term)
    end
  end
end
