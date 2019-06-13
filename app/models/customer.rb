class Customer < ApplicationRecord

  has_many :debtor_orders

  validates :name, presence: true
  # Customer
  #   -> Debtor Order
  #       -> Debtor Payment

  def customer_name
    "#{name}"
  end

  def self.debtor_payments(debtor_order_ids)
    DebtorPayment.where("debtor_order_id IN (?)", debtor_order_ids)
  end

  def self.debtor_orders(customer_id)
    DebtorOrder.where("customer_id = ?", customer_id)
  end

  def self.entities(customer_id)
    debtor_orders   = debtor_orders(   customer_id       )
    debtor_payments = debtor_payments( debtor_orders.ids )
    {
      debtor_orders: debtor_orders,
      debtor_payments: debtor_payments
    }
  end

  def self.removal_confirmation(customer_id)
    entities = entities(customer_id)
    confirmation = "Performing this removal will also delete: \n"

    confirmation << "* #{entities[:debtor_orders].count} Debtor Order records \n"
    confirmation << "    * #{entities[:debtor_payments].count} Debtor Payment records \n"

    confirmation << "Are you sure?"
  end

  def self.search(keywords, page)

    keywords_are_present = !keywords.nil? && keywords.responds_to?(:downcase)

    if keywords_are_present
      search_term = '%' + keywords.downcase + '%'

      if keywords =~ /\d/
        # search only phone
        where_term = %{
          phone LIKE ?
        }.gsub(/\s+/, " ").strip
        order_term = "phone asc"
        Customer.where(where_term, search_term).order(order_term).paginate(page)
      elsif keywords.include?("@")
        # search only email
        where_term = %{
          lower(email) LIKE ?
        }.gsub(/\s+/, " ").strip
        order_term = "email asc"
        Customer.where(where_term, search_term).order(order_term).paginate(page)
      else
        # search everything
        where_term = %{
          phone LIKE ?
          OR lower(email) LIKE ?
          OR lower(name) LIKE ?
        }.gsub(/\s+/, " ").strip
        order_term = "name asc"
        Customer.where(where_term, search_term, search_term, search_term).order(order_term).paginate(page)
      end
    else
      Customer.all.order("name asc").paginate(page)
    end
  end
end
