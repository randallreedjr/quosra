FactoryGirl.define do
  factory :category do
    title { |n| "#{Faker::Commerce.department}#{n}" }
  end
end
