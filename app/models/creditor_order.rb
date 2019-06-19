class CreditorOrder < ApplicationRecord

  belongs_to :supplier
  belongs_to :job

  has_many :credit_notes, dependent: :delete_all

  validates :date_issued, :value_excluding_tax, :tax_amount,
    :value_including_tax, :delivery_note, :reference_number, presence: true
  validates :value_excluding_tax, :tax_amount, :value_including_tax,
    numericality: { greater_than_or_equal_to: 0.0 }
  validates :value_excluding_tax,
    numericality: { less_than: :value_including_tax }
  validates :tax_amount,
    numericality: { less_than: :value_excluding_tax}

  # Creditor Order -> Creditor Payment (creditnote)

  def self.creditor_payments_count(creditor_order_id)
    CreditNote.where("creditor_order_id = ?", creditor_order_id).count(:all)
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
    paid = CreditNote.where(creditor_order_id: self.id).sum(:amount_paid)
    value - paid
  end

  def creditor_order_name
    "Supplier #{supplier.name}, job #{job.jce_number}"
  end

  # Search by:
  #   supplier:
  #     * name
  #     * email
  #     * phone
  #   Job:
  #     * JCE number
  #     * contact person
  #     * responsible_person
  #   Invoice:
  #     * Invoice code
  #     ** This changed: Invoices now belong to Payments, not Orders
  def self.search(keywords, dates, page, section_filter_id)

    # Let's first setup some named conditions on which we want to search
    omit_keywords = keywords.nil? || keywords.empty?
    skip_section_filter = section_filter_id.nil? || section_filter_id.empty?

    # Initialize @creditor_orders so we don't get NilError
    @creditor_orders = nil

    # Start by grabbing everything we need according to the search keywords
    unless omit_keywords
      is_email = !(( keywords =~ /@|\./ ).nil?)
      has_numbers = !(( keywords =~ /\d/ ).nil?)

      search_term = '%' + keywords.downcase + '%'

      if is_email
        where_term = %{
          lower(suppliers.email) LIKE ?
        }.gsub(/\s+/, " ").strip
        @creditor_orders = CreditorOrder.where(
          where_term,
          search_term
        )
      elsif has_numbers
        where_term = %{
          lower(creditor_orders.reference_number) LIKE ?
          OR lower(suppliers.email) LIKE ?
          OR suppliers.phone LIKE ?
          OR lower(jobs.jce_number) LIKE ?
        }.gsub(/\s+/, " ").strip
        @creditor_orders = CreditorOrder.where(
          where_term,
          search_term,
          search_term,
          search_term,
          search_term
        )
      else # search everything else
        where_term = %{
          lower(suppliers.name) LIKE ?
          OR lower(suppliers.email) LIKE ?
          OR lower(jobs.jce_number) LIKE ?
          OR lower(jobs.contact_person) LIKE ?
          OR lower(jobs.responsible_person) LIKE ?
          OR lower(creditor_orders.delivery_note) LIKE ?
          OR lower(creditor_orders.reference_number) LIKE ?
        }.gsub(/\s+/, " ").strip
        @creditor_orders = CreditorOrder.where(
          where_term,
          search_term,
          search_term,
          search_term,
          search_term,
          search_term,
          search_term,
          search_term
        )
      end
    else
      @creditor_orders = CreditorOrder.all
    end
    @creditor_orders = @creditor_orders.joins(:supplier, :job)

    # Then reduce the result set by filtering by dates, filters, etc
    if dates.has_start?
      # Creditor Orders for which Labor Date >= input date
      @creditor_orders = @creditor_orders.where("date_issued >= ?", dates.start_date)
    end
    if dates.has_end?
      # Creditor Orders for which Labor Date <= input date
      @creditor_orders = @creditor_orders.where("date_issued <= ?", dates.end_date)
    end
    unless skip_section_filter
      # Filter Creditor Orders by a specific section
      @creditor_orders = @creditor_orders.where(
        "jobs.section_id = ?", section_filter_id )
    end


    # Finally, do the ordering and pagination and such
    order_term = "suppliers.name asc, creditor_orders.date_issued desc"
    @creditor_orders = @creditor_orders.order(
      order_term
    ).paginate(
      page: page
    ).includes(
      job: :section
    )


  end
end
