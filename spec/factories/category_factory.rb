FactoryGirl.define do
  factory :category do
    sequence :title do |n|
      "#{Faker::Commerce.department}#{n}"
    end
  end
end
