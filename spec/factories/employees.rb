FactoryBot.define do
  factory :employee do
    first_name { "A" }
    last_name { "A" }
    occupation { "A" }
    section_id { FactoryBot.create(:section).id}
    company_number { "A" }
    net_rate { 10.0 }
    inclusive_rate { 12.4 }
    eoc { false }
  end

  factory :incorrect_employee, class: Employee do
    first_name { "B" }
    last_name { "B" }
    occupation { "B" }
    section_id { FactoryBot.create(:section, name: "B").id}
    company_number { "B" }
    net_rate { 10.0 }
    inclusive_rate { 12.4 }
    eoc { false }
  end
end
