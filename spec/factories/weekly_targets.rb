FactoryBot.define do
  factory :weekly_target do
    target_time { '3:00' }
    association :user
  end
end
