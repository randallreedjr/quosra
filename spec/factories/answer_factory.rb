FactoryGirl.define do
  factory :answer do
    content { Faker::Lorem.paragraph }
    question
    user
  end
end
