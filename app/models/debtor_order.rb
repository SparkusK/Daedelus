class DebtorOrder < ApplicationRecord
  belongs_to :customer
  belongs_to :job, optional: true
  belongs_to :invoice

  def debtor_order_name
    "Customer #{customer.name}"
  end
end
