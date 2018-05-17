class DebtorOrder < ApplicationRecord
  belongs_to :customer
  belongs_to :job
  belongs_to :invoice

  def debtor_order_name
    "Customer #{customer.name}, job #{job.jce_number}"
  end
end