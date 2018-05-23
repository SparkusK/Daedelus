class Invoice < ApplicationRecord
  def invoice_code
    "#{code}"
  end

  # Search by code
  def fuzzy_search(params)

  end
end
