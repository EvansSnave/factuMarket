FactoryBot.define do
  factory :bill do
    user_id { 1 }
    description { "Test bill" }
    amount { 100 }
    product { "Test product" }
    bill_date { Date.today }
  end
end
