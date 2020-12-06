FactoryBot.define do
  factory :user do
    name { 'Foo Bar' }
    sequence(:uid) { |n| "ExaMpleUiD#{n}" }
    sequence(:screen_name) { |n| "tester#{n}" }
    sequence(:email) { |n| "tester#{n}@example.com" }
    guest { false }

    trait :setting do
      after(:create) { |user| create(:setting, user: user) }
    end

    trait :thousand_exp do
      after(:create) { |user| create(:experience, user: user, total: 1000) }
    end

    trait :five_hundred_exp do
      after(:create) { |user| create(:experience, user: user, total: 500) }
    end

    trait :hundred_exp do
      after(:create) { |user| create(:experience, user: user, total: 100) }
    end

    trait :weekly_top do
      after(:create) do |user|
        create_list(:time_report, 3, :experience_record, user: user)
      end
    end

    trait :weekly_second do
      after(:create) do |user|
        create_list(:time_report, 2, :experience_record, user: user)
      end
    end

    trait :weekly_third do
      after(:create) do |user|
        create_list(:time_report, 1, :experience_record, user: user)
      end
    end
  end
end
