class Order < ApplicationRecord
  has_many :jobs, dependent: :delete_all

  def order_code
    "#{code}"
  end
end
