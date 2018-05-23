class DebtorOrder < ApplicationRecord
  belongs_to :customer
  belongs_to :job, optional: true
  belongs_to :invoice

  def debtor_order_name
    "Customer #{customer.name}"
  end

  # Search by customer.name, invoice.code, or SA_number
  def fuzzy_search(params)
    # if params contains numbers
      # search phone
    # else
      # search the rest
    # end
  end
end
