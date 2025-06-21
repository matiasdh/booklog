FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.paragraphs.join(". ") }
    association :user
    association :post
  end
end
