FactoryBot.define do
  factory :debtor_payment do
    debtor_order_id { FactoryBot.create(:debtor_order).id }
    payment_amount { 10.0 }
    payment_type { "A" }
    note { "A" }
    payment_date { Date.today }
    invoice_code { "A" }
  end
end
