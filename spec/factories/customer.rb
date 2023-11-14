FactoryBot.define do
  factory :customer do
    name { "A" }
    email { "A@A.A" }
    phone { "A" }
  end

  factory :incorrect_customer, class: Customer do
    name { "B" }
    email { "B@B.B" }
    phone { "B" }
  end
end
