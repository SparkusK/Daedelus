FactoryBot.define do
  factory :labor_record do
    employee_id { FactoryBot.create(:employee).id }
    labor_date { Date.today }
    hours { 8.5 }
    job_id { FactoryBot.create(:job).id }
    section_id { FactoryBot.create(:sample_section).id }
  end
end
