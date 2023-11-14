FactoryBot.define do
  factory :sample_section, class: Section do
    name { "Samples" }
    overheads { rand(1000) }
  end

  factory(:section) do
    name { "A" }
    overheads{ rand(1000) }
  end
end
