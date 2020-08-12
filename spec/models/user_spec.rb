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
  it { is_expected.to have_many(:comments) }
  it { is_expected.to have_one(:experience) }

  it '無効なユーザー名では登録に成功しないこと' do
    invalid_screen_name = %w[123-~@ 123:;{} 123?<>]
    invalid_screen_name.each do |name|
      user = build(:user, screen_name: name)
      expect(user).to_not be_valid
    end
  end

  it 'メールアドレスはユニークであること' do
    create(:user, email: 'foo@example.com')
    user = build(:user, email: 'foo@example.com')
    expect(user).to_not be_valid
  end

  it 'メールアドレスは大文字と小文字を区別しないこと' do
    create(:user, email: 'bar@example.com')
    user = build(:user, email: 'BAR@EXAMPLE.COM')
    expect(user).to_not be_valid
  end

  describe '#target_of_the_week' do
    it '今週の目標を返すこと' do
      prev_weekly_target = create(:weekly_target, :last_week, user: user)
      weekly_target = create(:weekly_target, user: user)
      expect(user.target_of_the_week[0]).to eq weekly_target
    end
  end

  describe '#target_of_non_checked' do
    it 'チェックされていない目標をチェック済みにすること' do
      prev_weekly_target = create(:weekly_target, :last_week, user: user)
      prev_weekly_target = user.target_of_non_checked
      expect(prev_weekly_target.checked).to be true
    end
  end

  describe 'experience_rank' do
    it '期間を指定しない場合、全ての期間のランキングが得られること' do
      top_user = create(:user, :thousand_exp)
      second_user = create(:user, :five_hundred_exp)
      third_user = create(:user, :hundred_exp)
      users = User.experience_rank
      expect(users.map(&:id)).to eq(
        [top_user, second_user, third_user].map(&:id)
      )
    end

    it '期間を指定して検索できること' do
      top_user = create(:user, :weekly_top)
      second_user = create(:user, :weekly_second)
      third_user = create(:user, :weekly_third)
      prev_week_report_of_third_user = create(:time_report, :experience_record,
        :last_week, user: third_user, study_time: '23:30'
      )
      term = Time.current.beginning_of_week
      users = User.experience_rank(term)
      expect(users.map(&:id)).to eq(
        [top_user, second_user, third_user].map(&:id)
      )
    end
  end

  describe '#timeline' do
    it 'フォローしているユーザーの投稿を返すこと' do
      other_user = create(:user)
      following_user = create(:user)
      other_user_time_report = create(:time_report, user: other_user)
      following_user_time_report = create(:time_report, :yesterday, user: following_user)
      following_user_time_report_old = create(:time_report, :last_week, user: following_user)
      user.follow(following_user)
      expect(user.timeline).to eq [following_user_time_report, following_user_time_report_old]
    end
  end

  describe 'search' do
    it 'nameの検索結果を最新順で返すこと' do
      user1 = create(:user, name: 'test uesr')
      user2 = create(:user, name: 'testing user')
      user3 = create(:user, name: 'foo')
      expect(User.search('test')).to eq [user2, user1]
    end
  end

  describe 'screen_name_search' do
    it 'screen_nameの検索結果を最新順で返すこと' do
      user1 = create(:user, screen_name: 'test1')
      user2 = create(:user, screen_name: 'testing')
      user3 = create(:user, screen_name: 'foobar')
      expect(User.screen_name_search('test')).to eq [user2, user1]
    end
  end
end
