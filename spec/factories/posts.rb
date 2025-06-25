FactoryBot.define do
  factory :post do
    association :user
    body { Faker::Lorem.paragraphs.join(". ") }

    trait :with_comments do
      transient do
        comments_count { 3 }
      end

      after(:create) do |post, context|
        create_list :comment, context.comments_count, post:
      end
    end
  end
end
