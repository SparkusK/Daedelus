FactoryBot.define do
  factory :correct_job, class: Job do
    responsible_person { "A" }
    contact_person { "A" }
    work_description { "A" }
    jce_number { "A" }
    quotation_reference { "A" }
    is_finished { "t" }
    job_number { "A" }
    order_number { "A" }
    client_section { "A" }
    total { rand(0.0..1000.0).truncate(2) }
    receive_date { Date.today }
    section_id { FactoryBot.create(:sample_section, name: "A").id }
  end

  factory :incorrect_job, class: Job do
    contact_person { "B" }
    responsible_person { "B" }
    work_description { "B" }
    jce_number { "B" }
    quotation_reference { "B" }
    is_finished { "t" }
    job_number { "B" }
    order_number { "B" }
    client_section { "B" }
    total { rand(0.0..1000.0).truncate(2) }
    receive_date { Date.today }
    section_id { FactoryBot.create(:sample_section, name: "B").id }
  end
end
