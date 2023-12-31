FactoryBot.define do
  factory :job_target do
    target_date { Date.today }
    invoice_number { "A" }
    remarks { "A" }
    details { "A" }
    target_amount { rand(0.0..1000.0).truncate(2) }
    section_id { FactoryBot.create(:sample_section).id }
    job_id { FactoryBot.create(:job).id }
  end
end
