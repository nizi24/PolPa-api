require 'rails_helper'

RSpec.describe "TimeReports", type: :request do

  let!(:user) { create(:user) }
  let!(:experience) { create(:experience, user: user) }

  describe '#create' do
    it 'タイムレポートが正しく保存されること' do
      time_report_params = attributes_for(:time_report, study_time: '1:30')
      expect {
        post v1_time_reports_path,
          params: {
            user_id: user.id,
            time_report: time_report_params
          }
      }.to change(user.time_reports, :count).by(1)
      experience_record = user.time_reports[0].experience_record
      expect(experience_record.experience_point).to eq 90
      expect(response.status).to eq 201
    end
  end
end
