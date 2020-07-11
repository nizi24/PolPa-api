require 'rails_helper'

RSpec.describe 'TimeReports', type: :request do

  let!(:user) { create(:user) }
  let!(:experience) { create(:experience, user: user) }

  describe '#show' do
    it 'タイムレポートと付属する情報が取得できること' do
      time_report = create(:time_report, :tags)
      create(:experience_record, time_report: time_report)
      get v1_time_report_path(time_report)
      json = JSON.parse(response.body)
      time_report = JSON.parse(json['time_report'])
      expect(response.status).to eq 200
      expect(time_report['study_time']).to eq '2000-01-01T00:30:00.000Z'
      expect(time_report['experience_record']['experience_point']).to eq 30
    end
  end

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

    it 'タグを付与できること' do
      time_report_params = attributes_for(:time_report, study_time: '1:30')
      tags = { 'tags' => [{ 'text' => 'foo'}, { 'text' => 'bar' }]}
      expect {
        post v1_time_reports_path,
          params: {
            user_id: user.id,
            time_report: time_report_params,
            tags: tags
          }
      }.to change(Tag, :count).by(2)
      expect(TimeReportTagLink.count).to eq 2
    end
  end

  describe '#update' do
    it 'タイムレポートが正しく更新されること' do
      time_report = create(:time_report, user: user)
      time_report_params = attributes_for(:time_report, study_time: '1:30')
      patch v1_time_report_path(time_report),
        params: {
          user_id: user.id,
          time_report: time_report_params
        }
      time_report.reload
      expect(time_report.study_time.hour).to eq 1
      expect(time_report.study_time.min).to eq 30
      experience_record = user.time_reports[0].experience_record
      expect(experience_record.experience_point).to eq 90
      expect(response.status).to eq 200
    end
  end

  describe '#destroy' do
    it 'タイムレポートが正しく破棄されること' do
      time_report = create(:time_report, user: user)
      experience_record = create(:experience_record, time_report: time_report)
      expect {
        delete v1_time_report_path(time_report),
          params: {
            user_id: user.id
          }
      }.to change(user.time_reports, :count).by(-1)
    end

    it '紐付いたタグも削除されること' do
      time_report = create(:time_report, :tags, user: user)
      experience_record = create(:experience_record, time_report: time_report)
      expect {
        delete v1_time_report_path(time_report),
          params: {
            user_id: user.id
          }
      }.to change(TimeReportTagLink, :count).by(-3)
    end

    it 'コメントも削除されること' do
      time_report = create(:time_report, :comments, user: user)
      experience_record = create(:experience_record, time_report: time_report)
      expect {
        delete v1_time_report_path(time_report),
          params: {
            user_id: user.id
          }
      }.to change(Comment, :count).by(-3)
    end
  end
end
