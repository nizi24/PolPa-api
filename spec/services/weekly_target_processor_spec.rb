require 'rails_helper'

describe WeeklyTargetProcessor do
  let(:user) { create(:user) }

  describe '#totalization' do
    it '一週間の勉強時間を集計すること' do
      time_reports = create_list(:time_report, 3, user: user)
      prev_week_report = create(:time_report, :last_week, user: user)
      weekly_target = create(:weekly_target, user: user)
      WeeklyTargetProcessor.new(user).totalization(weekly_target)
      byebug
      expect(weekly_target.process).to eq 90
    end
  end
end
