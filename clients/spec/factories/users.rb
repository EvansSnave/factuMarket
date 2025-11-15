FactoryBot.define do
  factory :user do
    name { "Test User" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password12" }
    password_confirmation { "password12" }
    identification { rand(100_000..900_000) }
  end
end
