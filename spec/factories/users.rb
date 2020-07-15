FactoryBot.define do
  factory :user do
    name { 'Foo Bar'}
    sequence(:uid) { |n| "ExaMpleUiD#{n}" }
    sequence(:screen_name) { |n| "tester#{n}" }
    sequence(:email) { |n| "tester#{n}@example.com" }

    trait :time_reports do
      after(:create) do |time_report|
      end
    end
  end
end
