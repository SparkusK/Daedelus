class DebtorOrder < ApplicationRecord
  include Searchable
  belongs_to :customer
  belongs_to :job, optional: true

  has_many :debtor_payments, dependent: :delete_all

  validates :order_number, :value_excluding_tax, :tax_amount,
    :value_excluding_tax, presence: true

  validates :value_excluding_tax, :tax_amount, :value_including_tax,
    numericality: { greater_than_or_equal_to: 0.0 }

  validates :value_excluding_tax, numericality: { less_than: :value_including_tax}
  validates :tax_amount, numericality: { less_than: :value_excluding_tax}

  # Debtor Order -> Debtor Payment

  def self.debtor_payments_count(debtor_order_id)
    DebtorPayment.where("debtor_order_id = ?", debtor_order_id).count(:all)
  end

  def self.removal_confirmation(debtor_order_id)
    count = debtor_payments_count(debtor_order_id)
    confirmation = "Performing this removal will also delete: \n"

    confirmation << "* #{count} Debtor Payment records \n"

    confirmation << "Are you sure?"
  end

  def debtor_order_name
    "#{customer.name}"
  end

  def still_owed_amount
    value = self.value_excluding_tax
    # Sum all payment amounts of debtor payments with debtor_order_id = self.id
    paid = DebtorPayment.where(debtor_order_id: self.id).sum(:payment_amount)
    still_owed = value - paid
  end

  private

# ======= SEARCH ========================================

  def self.keyword_search_attributes
    %w{ customers.phone customers.name customers.email jobs.jce_number
    jobs.contact_person jobs.responsible_person debtor_orders.order_number }
  end

  def self.subclassed_filters(args)
    Search::Filter::DateRangeFilter.new("debtor_orders.updated_at", args[:updated_dates])
  end

  def self.subclassed_search_defaults
    { updated_dates: Utility::DateRange.new(start_date: nil, end_date: nil) }
  end

  def self.subclassed_order_term
    "customers.name asc, debtor_orders.value_excluding_tax desc"
  end

  def self.subclassed_join_list
    :customer
  end

  def self.subclassed_left_outer_joins_list
    :job
  end

  def self.subclassed_includes_list
    :customer
  end
end
