class CreditorOrder < ApplicationRecord
  belongs_to :supplier
  belongs_to :job
  belongs_to :invoice

  def creditor_order_name
    "Supplier #{supplier.name}, job #{job.jce_number}"
  end

  # Search by supplier.name, invoice.code
  def fuzzy_search(params)
    # if params contains numbers
      # search phone
    # else
      # search the rest
    # end
  end
end
