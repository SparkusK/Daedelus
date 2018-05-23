class DebtorPayment < ApplicationRecord
  belongs_to :debtor_order

  # Search by debtor_order.name or payment_type
  def fuzzy_search(params)
    # if params contains numbers
      # search phone
    # else
      # search the rest
    # end
  end
end
