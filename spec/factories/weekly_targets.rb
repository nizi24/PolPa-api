FactoryBot.define do
  factory :weekly_target do
    target_time { '3:00' }
    association :user
    start_date { Time.current.beginning_of_week }
    end_date { Time.current.end_of_week }

    trait :last_week do
      start_date { Time.current.prev_week.beginning_of_week }
      end_date { Time.current.prev_week.end_of_week }
    end
  end
end
