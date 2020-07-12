FactoryBot.define do
  factory :comment do
    content { 'すごい！' }
    association :user
    association :time_report
  end
end
