FactoryBot.define do
  factory :experience do
    association :user
    level { 1 }
    experience { 0 }
    experience_to_next { 50 }
  end
end
