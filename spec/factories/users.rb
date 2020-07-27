FactoryBot.define do
  factory :user do
    name { 'Foo Bar'}
    sequence(:uid) { |n| "ExaMpleUiD#{n}" }
    sequence(:screen_name) { |n| "tester#{n}" }
    sequence(:email) { |n| "tester#{n}@example.com" }

    trait :setting do
      after(:create) { |user| create(:setting, user: user) }
    end
  end
end
