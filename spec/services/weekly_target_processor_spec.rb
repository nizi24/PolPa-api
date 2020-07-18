require 'rails_helper'

describe WeeklyTargetProcessor do
  let(:user) { create(:user) }

  describe '#totalization' do
    it '一週間の勉強時間を集計すること' do
      time_reports = create_list(:time_report, 3, user: user)
      prev_week_report = create(:time_report, :last_week, user: user)
      weekly_target = create(:weekly_target, user: user)
      WeeklyTargetProcessor.new(user).totalization(weekly_target)
      expect(weekly_target.progress).to eq '2000-01-01 01:30:00.000000000 +0900'
    end
  end

  describe 'add_progress' do
    it 'タイムレポートの時間が加算されること' do
      weekly_target = create(:weekly_target, user: user)
      WeeklyTargetProcessor.new(user).totalization(weekly_target)
      time_report = create(:time_report, study_time: '1:30', user: user)
      weekly_target = WeeklyTargetProcessor.new(user).add_progress(time_report)
      expect(weekly_target.progress).to eq '2000-01-01 01:30:00.000000000 +0900'
    end
  end
end
