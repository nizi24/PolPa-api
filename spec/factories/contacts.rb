FactoryBot.define do
  factory :contact do
    name { 'tester' }
    email { 'test@example.com' }
    message { 'foo bar' }
  end
end
