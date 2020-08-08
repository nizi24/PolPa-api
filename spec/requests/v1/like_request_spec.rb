require 'rails_helper'

RSpec.describe "V1::Like", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user, :setting) }
  let(:time_report) { create(:time_report, :setting) }
  let(:comment) { create(:comment, :setting) }

  describe '#create' do
    it 'time_reportにlikeできること' do
      like_params = {
        likeable_id: time_report.id,
        likeable_type: 'TimeReport',
        user_id: user.id
      }
      expect {
        post v1_like_path, params: { like: like_params }
      }.to change(time_report.likes, :count).by(1)
    end

    it 'commentにlikeできること' do
      like_params = {
        likeable_id: comment.id,
        likeable_type: 'Comment',
        user_id: user.id
      }
      expect {
        post v1_like_path, params: { like: like_params }
      }.to change(comment.likes, :count).by(1)
    end

    it 'time_reportにlikeした時に通知が送信されること' do
      like_params = {
        likeable_id: time_report.id,
        likeable_type: 'TimeReport',
        user_id: user.id
      }
      expect {
        post v1_like_path, params: { like: like_params }
      }.to change(time_report.user.notices, :count).by(1)
    end

    it 'commentにlikeした時に通知が送信されること' do
      like_params = {
        likeable_id: comment.id,
        likeable_type: 'Comment',
        user_id: user.id
      }
      expect {
        post v1_like_path, params: { like: like_params }
      }.to change(comment.user.notices, :count).by(1)
    end

    it '投稿のユーザーの設定がfalseの時は通知は作られないこと' do
      time_report = create(:time_report, user: other_user)
      like_params = {
        likeable_id: time_report.id,
        likeable_type: 'TimeReport',
        user_id: user.id
      }
      other_user.setting.update(time_report_like_notice: false)
      expect{
        post v1_like_path, params: { like: like_params }
      }.to_not change(other_user.notices, :count)
    end
  end

  describe '#destroy' do
    it 'time_reportのlikeを解除できること' do
      like_params = {
        likeable_id: time_report.id,
        likeable_type: 'TimeReport',
        user_id: user.id
      }
      post v1_like_path, params: { like: like_params }
      expect {
        delete delete_v1_like_path, params: { like: like_params.to_json }
      }.to change(time_report.likes, :count).by(-1)
    end

    it 'commentのlikeを解除できること' do
      like_params = {
        likeable_id: comment.id,
        likeable_type: 'Comment',
        user_id: user.id
      }
      post v1_like_path, params: { like: like_params }
      expect {
        delete delete_v1_like_path, params: { like: like_params.to_json }
      }.to change(comment.likes, :count).by(-1)
    end
  end
end
