class Customer < ApplicationRecord
  include Searchable
  has_many :debtor_orders, dependent: :delete_all

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

  private

# ======= SEARCH ========================================

  def self.keyword_search_attributes
    %w{ phone email name }
  end

  def self.subclassed_order_term
    "name asc"
  end
end
