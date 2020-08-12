FactoryBot.define do
  factory :experience do
    association :user
    level { 1 }
    total { 0 }
    to_next { 50 }
  end
end
