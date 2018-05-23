class Quotation < ApplicationRecord
  has_many :jobs

  def quotation_code
    "#{code}"
  end

  # Search by code
  def fuzzy_search(params)

  end
end
