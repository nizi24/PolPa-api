FactoryBot.define do
  factory :time_report do
    study_time { '0:30' }
    memo { '頑張りました!' }
    study_date { Time.current }
    association :user

    trait :setting do
      after(:create) { |t| create(:setting, user: t.user )}
    end

    trait :tags do
      after(:create) do |time_report|
        create_list(:tag, 3, time_reports: [time_report])
      end
    end

    trait :comments do
      after(:create) { |t| create_list(:comment, 3, time_report: t) }
    end

    trait :yesterday do
      study_date { Time.current.yesterday }
    end

    trait :last_week do
      study_date { Time.current.prev_week.ago(1.hours) }
    end

    trait :experience_record do
      after(:create) do |t|
        hours = t.study_time.hour
        minutes = t.study_time.min
        gain_exp = hours * 60 + minutes
        create(:experience_record, time_report: t,
          user: t.user, experience_point: gain_exp
        )
      end
    end
  end
end
