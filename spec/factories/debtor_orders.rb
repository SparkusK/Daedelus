FactoryBot.define do
  factory :debtor_order do
    customer_id { FactoryBot.create(:customer).id }
    job_id { FactoryBot.create(:job).id }
    order_number { "A" }
    value_including_tax { 10.0 }
    tax_amount { 10.0*0.2 }
    value_excluding_tax { 10.0*1.2 }
  end
end
