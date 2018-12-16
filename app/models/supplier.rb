class Supplier < ApplicationRecord

  has_many :creditor_orders

  validates :name, presence: true
  # Supplier
  #   -> creditor_order
  #       -> creditor_payment

  def self.get_credit_notes(creditor_order_ids)
    CreditNote.where("creditor_order_id IN (?)", creditor_order_ids)
  end

  def self.get_creditor_orders(supplier_id)
    CreditorOrder.where("supplier_id = ?", supplier_id)
  end

  def self.get_entities(supplier_id)
    creditor_orders = get_creditor_orders( supplier_id         )
    credit_notes    = get_credit_notes(    creditor_orders.ids )
    {
      creditor_orders: creditor_orders,
      credit_notes: credit_notes
    }
  end

  def self.get_removal_confirmation(supplier_id)
    entities = get_entities(supplier_id)
    confirmation = "Performing this removal will also delete: \n"

    confirmation << "* #{entities[:creditor_orders].count} Creditor Order records \n"
    confirmation << "    * #{entities[:credit_notes].count} Creditor Payment records \n"

    confirmation << "Are you sure?"
  end

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
