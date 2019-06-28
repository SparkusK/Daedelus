class DebtorPayment < ApplicationRecord
  include Searchable

  belongs_to :debtor_order

  validates_each :payment_amount do |record, attr, value|
    record.errors.add(attr, "Can't pay more than is still owed") if
      value > record.debtor_order.still_owed_amount
    end
  validates :payment_amount, numericality: { greater_than_or_equal_to: 0.0 }
  validates :payment_date, :payment_amount, :payment_type, :note, :invoice_code,
    presence: true

  def format_payment_date
    if payment_date.nil?
      ""
    else
      payment_date.strftime("%a, %d %b %Y: %H:%M:%S")
    end
  end

  private

# ======= SEARCH ========================================

  def self.keyword_search_attributes
    %w{ customers.name debtor_payments.payment_type debtor_payments.note debtor_payments.invoice_code }
  end

  def self.subclassed_filters(args)
    [Search::Filter::DateRangeFilter.new("payment_date", args[:payment_dates])]
  end

  def self.subclassed_search_defaults
    { payment_dates: Utility::DateRange.new(start_date: nil, end_date: nil) }
  end

  def self.subclassed_order_term
    "debtor_payments.payment_date desc"
  end

  def self.subclassed_join_list
    {:debtor_order => :customer}
  end

  def self.subclassed_includes_list
    {:debtor_order => :customer}
  end
end
