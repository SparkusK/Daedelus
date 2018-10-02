class DebtorPayment < ApplicationRecord
  belongs_to :debtor_order
  validates_each :payment_amount do |record, attr, value|
    record.errors.add(attr, "Can't pay more than is still owed") if
      value > record.debtor_order.get_still_owed_amount
    end

  def get_payment_date
    if payment_date.nil?
      ""
    else
      payment_date.strftime("%a, %d %b %Y: %H:%M:%S")
    end
  end

  def self.search(keywords, start_date, end_date, page)



    if keywords.nil?
      where_term = "payment_date > ? AND payment_date < ?"
      order_term = "debtor_payments.payment_date desc"
      DebtorPayment.where(
        where_term,
        start_date,
        end_date
      ).order(
        order_term
      ).paginate(
        page: page
      ).includes(
        debtor_order: :customer
      )
    else
      search_term = '%' + keywords.downcase + '%'
      where_term = %{
        lower(customers.name) LIKE ?
        OR lower(debtor_payments.payment_type) LIKE ?
        OR lower(debtor_payments.note) LIKE ?
        AND payment_date > ? AND payment_date < ?
      }.gsub(/\s+/, " ").strip

      order_term = "debtor_payments.payment_date desc"

      DebtorPayment.joins(
        debtor_order: :customer
      ).where(
        where_term,
        search_term,
        search_term,
        search_term,
        start_date,
        end_date
      ).order(
        order_term
      ).paginate(
        page: page
      ).includes(
        debtor_order: :customer
      )
    end
  end

  # def show_invoice_code
  #   self.invoice.nil? ? "" : self.invoice.code
  # end
  #
  # def self.invoice_ids
  #   self.select(:invoice_id)
  # end

end
