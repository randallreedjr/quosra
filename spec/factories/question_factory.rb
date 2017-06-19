FactoryGirl.define do
  factory :question do
    title { Faker::Book.title }
    description { Faker::HarryPotter.quote }
    user

    trait :with_category do
      after(:create) { |question| question.categories << FactoryGirl.create(:category) }
    end

    trait :with_answer do
      after(:create) { |question| question.answers << FactoryGirl.create(:answer) }
    end
  end
end
