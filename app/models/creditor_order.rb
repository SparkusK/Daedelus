class CreditorOrder < ApplicationRecord
  include Searchable

  belongs_to :supplier
  belongs_to :job

  has_many :creditor_payments, dependent: :delete_all

  validates :date_issued, :value_excluding_tax, :tax_amount,
    :value_including_tax, :delivery_note, :reference_number, presence: true
  validates :value_excluding_tax, :tax_amount, :value_including_tax,
    numericality: { greater_than_or_equal_to: 0.0 }
  validates :value_excluding_tax,
    numericality: { less_than: :value_including_tax }
  validates :tax_amount,
    numericality: { less_than: :value_excluding_tax}

  # Creditor Order -> Creditor Payment (CreditorPayment)

  def self.creditor_payments_count(creditor_order_id)
    CreditorPayment.where("creditor_order_id = ?", creditor_order_id).count(:all)
  end

  def self.removal_confirmation(creditor_order_id)
    count = creditor_payments_count(creditor_order_id)
    confirmation = "Performing this removal will also delete: \n"

    confirmation << "* #{count} Creditor Payment records \n"

    confirmation << "Are you sure?"
  end

  def still_owed_amount
    value = self.value_excluding_tax
    # Sum all payment amounts of debtor payments with debtor_order_id = self.id
    paid = CreditorPayment.where(creditor_order_id: self.id).sum(:amount_paid)
    value - paid
  end

  def creditor_order_name
    "Supplier #{supplier.name}, job #{job.jce_number}"
  end

  private

# ======= SEARCH ========================================

  def self.keyword_search_attributes
    %w{ suppliers.phone suppliers.name suppliers.email jobs.jce_number
      jobs.contact_person jobs.responsible_person
      creditor_orders.delivery_note creditor_orders.reference_number }
  end

  def self.subclassed_filters(args)
    filters = []
    filters << Search::Filter::SectionIdFilter.new(args[:section_filter_id])
    filters << Search::Filter::DateRangeFilter.new("date_issued", args[:issued_dates])
    filters
  end

  def self.subclassed_search_defaults
    { issued_dates: Utility::DateRange.new(start_date: nil, end_date: nil),
      section_filter_id: nil }
  end

  def self.subclassed_order_term
    "suppliers.name asc, creditor_orders.date_issued desc"
  end

  def self.subclassed_join_list
    [ :supplier, :job ]
  end

  def self.subclassed_includes_list
    [ job: :section]
  end
end
