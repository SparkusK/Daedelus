class Quotation < ApplicationRecord
  has_many :jobs

  def quotation_code
    "#{code}"
  end
end
