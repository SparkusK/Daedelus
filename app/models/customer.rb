class Customer < ApplicationRecord
  def customer_name
    "#{name}"
  end
end
