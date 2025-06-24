FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.paragraphs }
    association :user
    association :post
  end
end
