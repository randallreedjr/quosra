FactoryGirl.define do
  factory :question do
    title { Faker::Book.title }
    description { Faker::HarryPotter.quote }
  end
end