class CreditNote < ApplicationRecord
  belongs_to :creditor_order

  # Search by creditor_order.job.jce_number,
  #           creditor_order.supplier.name,
  #           payment_type
  def fuzzy_search(params)
    # if params contains numbers
      # search phone
    # else
      # search the rest
    # end
  end
end
