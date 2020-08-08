FactoryBot.define do
  factory :setting do
    association :user
    comment_notice { true }
    comment_like_notice { true }
    time_report_like_notice { true }
    follow_notice { true }
  end
end
