class CreditorOrder < ApplicationRecord
  belongs_to :supplier
  belongs_to :job
  belongs_to :invoice

  def creditor_order_name
    "Supplier #{supplier.name}, job #{job.jce_number}"
  end
end
