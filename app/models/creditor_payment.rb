class CreditorPayment < ApplicationRecord
  include Searchable
  belongs_to :creditor_order
  validates_each :amount_paid do |record, attr, value|
    record.errors.add(attr, "Can't pay more than is still owed") if
      value > record.creditor_order.still_owed_amount
  end

  validates :amount_paid, numericality: { greater_than_or_equal_to: 0.0 }

  validates :invoice_code, :amount_paid, :payment_type, :note, presence: true

  private

# ======= SEARCH ========================================

  def self.keyword_search_attributes
    %w{ suppliers.name creditor_payments.payment_type creditor_payments.note jobs.jce_number }
  end

  def self.subclassed_filters(args)
    [Search::Filter::DateRangeFilter.new("creditor_payments.updated_at", args[:updated_dates])]
  end

  def self.subclassed_search_defaults
    { updated_dates: Utility::DateRange.new(start_date: nil, end_date: nil) }
  end

  def self.subclassed_order_term
    "creditor_payments.updated_at desc"
  end

  def self.subclassed_join_list
    [{creditor_order: [:job, :supplier]}]
  end

  def self.subclassed_includes_list
    [{creditor_order: [:job, :supplier]}]
  end
end
