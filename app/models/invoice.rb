class Invoice < ApplicationRecord
  def invoice_code
    "#{code}"
  end
end
