FactoryBot.define do
  factory :post do
    association :user
    body { Faker::Lorem.paragraphs.join(". ") }
  end
end
