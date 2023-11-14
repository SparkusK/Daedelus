FactoryBot.define do
  factory :manager do
    employee_id { FactoryBot.create(:employee).id }
    section_id { FactoryBot.create(:section).id }
  end
end
