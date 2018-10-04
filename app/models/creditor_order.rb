class CreditorOrder < ApplicationRecord
  belongs_to :supplier
  belongs_to :job

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
          lower(suppliers.email) LIKE ?
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
