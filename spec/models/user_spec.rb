require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { create(:user) }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name) }
  it { is_expected.to validate_presence_of(:screen_name) }
  it { is_expected.to validate_length_of(:screen_name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_length_of(:email) }
  it { is_expected.to have_many(:time_reports) }
  it { is_expected.to have_many(:experience_records) }
  it { is_expected.to have_one(:experience) }

  it '無効なユーザー名では登録に成功しないこと' do
    invalid_screen_name = %w[123-~@ 123:;{} 123?<>]
    invalid_screen_name.each do |name|
      user = FactoryBot.build(:user, screen_name: name)
      expect(user).to_not be_valid
    end
  end

  it 'メールアドレスはユニークであること' do
    FactoryBot.create(:user, email: 'foo@example.com')
    user = FactoryBot.build(:user, email: 'foo@example.com')
    expect(user).to_not be_valid
  end

  it 'メールアドレスは大文字と小文字を区別しないこと' do
    FactoryBot.create(:user, email: 'bar@example.com')
    user = FactoryBot.build(:user, email: 'BAR@EXAMPLE.COM')
    expect(user).to_not be_valid
  end

end
