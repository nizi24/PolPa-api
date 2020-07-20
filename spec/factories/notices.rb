FactoryBot.define do
  factory :comment_notice, class: 'Notice' do
    association :user
    association :noticeable, factory: :comment
    checked { false }
  end
end
