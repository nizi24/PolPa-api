FactoryBot.define do
  factory :time_report do
    study_time { '0:30' }
    memo { '頑張りました!' }
    association :user
  end
end
