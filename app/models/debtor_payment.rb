class DebtorPayment < ApplicationRecord
  belongs_to :debtor_order
end
