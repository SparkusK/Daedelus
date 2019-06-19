FactoryBot.define do
  factory :creditor_order do
    supplier_id { FactoryBot.create(:supplier).id }
    job_id { FactoryBot.create(:job).id }
    delivery_note { "A" }
    date_issued { Date.today }
    value_excluding_tax { 10.0 }
    tax_amount { 10.0*0.2 }
    value_including_tax { 10.0*1.2 }
    reference_number { "A" }
  end
end
