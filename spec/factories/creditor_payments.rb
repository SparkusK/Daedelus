FactoryBot.define do
  factory :creditor_payment, class: CreditNote do
    creditor_order_id { FactoryBot.create(:creditor_order).id }
    payment_type { "A" }
    amount_paid { 10.0 }
    note { "A" }
    invoice_code { "A" }
  end
end
