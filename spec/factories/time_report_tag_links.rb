FactoryBot.define do
  factory :time_report_tag_link do
    association :time_report
    association :tag
  end
end
