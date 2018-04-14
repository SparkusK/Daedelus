class Order < ApplicationRecord
  has_many :jobs

  def order_code
    "#{code}"
  end
end
