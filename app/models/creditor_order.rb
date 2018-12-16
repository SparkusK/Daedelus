class CreditorOrder < ApplicationRecord
  belongs_to :supplier
  belongs_to :job

  has_many :credit_notes

  validates :date_issued, :value_excluding_tax, :tax_amount,
    :value_including_tax, :delivery_note, :reference_number, presence: true
  # Creditor Order -> Creditor Payment (creditnote)

  def self.get_creditor_payments_count(creditor_order_id)
    CreditNote.where("creditor_order_id = ?", creditor_order_id).count(:all)
  end

  def self.get_removal_confirmation(creditor_order_id)
    count = get_creditor_payments_count(creditor_order_id)
    confirmation = "Performing this removal will also delete: \n"

    confirmation << "* #{count} Creditor Payment records \n"

    confirmation << "Are you sure?"
  end

  def get_still_owed_amount
    value = self.value_excluding_tax
    # Sum all payment amounts of debtor payments with debtor_order_id = self.id
    paid = CreditNote.where(creditor_order_id: self.id).sum(:amount_paid)
    still_owed = value - paid
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
  def self.search(keywords, start_date, end_date, page)

    if keywords.nil?

      where_term = %{
        date_issued >= ? AND date_issued <= ?
      }.gsub(/\s+/, " ").strip

      order_term = "creditor_orders.value_including_tax desc"

      CreditorOrder.joins(
        :supplier, :job
      ).where(
        where_term,
        start_date,
        end_date
      ).order(
        order_term
      ).paginate(
        page: page
      ).includes(
        :supplier, job: :section
      )

    else
      is_email = !(( keywords =~ /@|\./ ).nil?)
      has_numbers = !(( keywords =~ /\d/ ).nil?)

      search_term = '%' + keywords.downcase + '%'

      if is_email
        where_term = %{
          lower(suppliers.email) LIKE ?
          AND date_issued >= ? AND date_issued <= ?
        }.gsub(/\s+/, " ").strip

        order_term = "suppliers.email asc"

        CreditorOrder.joins(
          :supplier, :job
        ).where(
          where_term,
          search_term,
          start_date,
          end_date
        ).order(
          order_term
        ).paginate(
          page: page
        ).includes(
          :supplier, job: :section
        )

      elsif has_numbers
        where_term = %{
          lower(creditor_orders.reference_number) LIKE ?
          OR lower(suppliers.email) LIKE ?
          OR suppliers.phone LIKE ?
          OR lower(jobs.jce_number) LIKE ?
          AND date_issued >= ? AND date_issued <= ?
        }.gsub(/\s+/, " ").strip

        order_term = "creditor_orders.value_including_tax desc"

        CreditorOrder.joins(
          :supplier, :job
        ).where(
          where_term,
          search_term,
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
          :supplier, job: :section
        )
      else
        where_term = %{
          lower(suppliers.name) LIKE ?
          OR lower(suppliers.email) LIKE ?
          OR lower(jobs.jce_number) LIKE ?
          OR lower(jobs.contact_person) LIKE ?
          OR lower(jobs.responsible_person) LIKE ?
          OR lower(creditor_orders.delivery_note) LIKE ?
          OR lower(creditor_orders.reference_number) LIKE ?
          AND date_issued >= ? AND date_issued <= ?
        }.gsub(/\s+/, " ").strip

        order_term = "suppliers.name asc, creditor_orders.value_including_tax desc"

        CreditorOrder.joins(
          :supplier, :job
        ).where(
          where_term,
          search_term,
          search_term,
          search_term,
          search_term,
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
          :supplier, job: :section
        )
      end
    end
  end
end
