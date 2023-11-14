FactoryBot.define do
  factory :supplier do
    name { "A" }
    email { "A@A.A" }
    phone { "A" }
  end

  factory :incorrect_supplier, class: Supplier do
    name { "B" }
    email { "B@B.B" }
    phone { "B" }
  end
end
