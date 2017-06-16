FactoryGirl.define do
  factory :answer do
    content { Faker::Lorem.paragraph }
    question
  end
end
