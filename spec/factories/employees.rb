FactoryBot.define do
  factory :employee do
    first_name { "A" }
    last_name { "A" }
    occupation { "A" }
    section_id { FactoryBot.create(:section).id }
    company_number { "A" }
    net_rate { 10.0 }
    inclusive_rate { 10.0 }
    eoc { false }
  end
end
