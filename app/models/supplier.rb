class Supplier < ApplicationRecord
  include Searchable
  has_many :creditor_orders, dependent: :delete_all

  validates :name, presence: true
  # Supplier
  #   -> creditor_order
  #       -> creditor_payment

  def self.creditor_payments(creditor_order_ids)
    CreditorPayment.where("creditor_order_id IN (?)", creditor_order_ids)
  end

  def self.creditor_orders(supplier_id)
    CreditorOrder.where("supplier_id = ?", supplier_id)
  end

  def self.entities(supplier_id)
    creditor_orders = creditor_orders( supplier_id         )
    creditor_payments    = creditor_payments(    creditor_orders.ids )
    {
      creditor_orders: creditor_orders,
      creditor_payments: creditor_payments
    }
  end

  def self.removal_confirmation(supplier_id)
    entities = entities(supplier_id)
    confirmation = "Performing this removal will also delete: \n"

    confirmation << "* #{entities[:creditor_orders].count} Creditor Order records \n"
    confirmation << "    * #{entities[:creditor_payments].count} Creditor Payment records \n"

    confirmation << "Are you sure?"
  end

  def supplier_name
    "#{name}"
  end

  def removal_confirmation
    confirmation = "Performing this removal will also delete: \n"
    confirmation << "* #{self.creditor_orders.count} Creditor Order records, including: \n" unless self.creditor_orders.nil?
    creditor_orders_payments_total = 0
    self.creditor_orders.each do |creditor_order|
      creditor_orders_payments_total += creditor_order.creditor_payments.count unless creditor_order.creditor_payments.nil?
    end
    confirmation << "  * #{creditor_orders_payments_total} Creditor Payments from Creditor Orders \n"
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
