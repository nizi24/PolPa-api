FactoryBot.define do
  factory :tag do
    sequence(:name) { |n| "Rails#{n}" }
  end
end
