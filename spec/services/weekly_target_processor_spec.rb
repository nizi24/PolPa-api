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

  describe '#add_progress' do
    it 'タイムレポートの時間が加算されること' do
      weekly_target = create(:weekly_target, user: user)
      WeeklyTargetProcessor.new(user).totalization(weekly_target)
      time_report = create(:time_report, study_time: '1:30', user: user)
      weekly_target = WeeklyTargetProcessor.new(user).add_progress(time_report)
      expect(weekly_target.progress).to eq '2000-01-01 01:30:00.000000000 +0900'
    end
  end

  describe '#sub_progress' do
    it 'タイムレポートの時間が減算されること' do
      weekly_target = create(:weekly_target, user: user)
      time_report = create(:time_report, study_time: '1:30', user: user)
      WeeklyTargetProcessor.new(user).totalization(weekly_target)
      time_report.update(study_time: '0:30')
      weekly_target = WeeklyTargetProcessor.new(user).sub_progress(time_report)
      expect(weekly_target.progress).to eq '2000-01-01 01:00:00.000000000 +0900'
    end
  end

  describe '#experience_record' do
    it '経験値が加算されること' do
      experience = create(:experience, user: user)
      weekly_target = create(:weekly_target, target_time: '2000-01-02 00:30',
        user: user)
      time_report = create(:time_report, study_time: '4:30', user: user)
      time_report_second = create(:time_report, study_time: '20:30', user: user)
      WeeklyTargetProcessor.new(user).totalization(weekly_target)
      weekly_target.reload
      expect {
        WeeklyTargetProcessor.new(user).experience_record(weekly_target)
      }.to change(WeeklyTargetExperienceRecord, :count).by(1)
      user.experience.reload
      expect(user.experience.total).to eq 590
      expect(user.experience.level).to eq 10
    end
  end
end
