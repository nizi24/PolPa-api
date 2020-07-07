FactoryBot.define do
  factory :experience_record do
    experience_point { 30 }
    bonus_multiplier { 1.0 }
    association :time_report
    association :user
  end
end
