require 'rails_helper'

describe 'jj' do

  let!(:user) { create(:user) }
  let!(:experience) { create(:experience, user: user) }

  it '日付比較' do
    last_three_days = (3.days.ago.beginning_of_day..Time.current.end_of_day)
    time_report = create(:time_report, study_date: 3.days.ago)
    expect(last_three_days.include?(time_report.study_date)).to eq true
  end
end
