FactoryBot.define do
  factory :comment do
    content { 'すごい！' }
    association :user
    association :time_report

    trait :setting do
      after(:create) { |c| create(:setting, user: c.user) }
    end
  end
end
