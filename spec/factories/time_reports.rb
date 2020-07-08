FactoryBot.define do
  factory :time_report do
    study_time { '0:30' }
    memo { '頑張りました!' }
    association :user

    trait :tags do
      after(:create) do |time_report|
        create_list(:tag, 3, time_reports: [time_report])
      end
    end
  end
end
