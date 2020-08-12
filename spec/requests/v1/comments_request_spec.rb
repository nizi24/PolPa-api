require 'rails_helper'

RSpec.describe "V1::Comments", type: :request do
  let(:user) { create(:user, :setting) }
  let(:other_user) { create(:user, :setting) }
  let(:time_report) { create(:time_report, :setting) }

  describe '#create' do
    it 'コメントを作成できること' do
      comment_params = attributes_for(:comment, user_id: user.id,
        time_report_id: time_report.id)
      expect {
        expect {
          post v1_comments_path, params: { comment: comment_params }
        }.to change(user.comments, :count).by(1)
      }.to change(time_report.comments, :count).by(1)
    end

    it '通知が作成されること' do
      comment_params = attributes_for(:comment, user_id: user.id,
        time_report_id: time_report.id)
      expect {
        post v1_comments_path, params: { comment: comment_params }
      }.to change(time_report.user.notices, :count).by(1)
    end

    it '自分の投稿に自分でコメントしても通知は送信されないこと' do
      time_report = create(:time_report, user: user)
      comment_params = attributes_for(:comment, user_id: user.id,
        time_report_id: time_report.id)
      expect {
        post v1_comments_path, params: { comment: comment_params }
      }.to_not change(user.notices, :count)
    end

    it '投稿のユーザーの設定がfalseの時は通知は作られないこと' do
      time_report = create(:time_report, user: user)
      comment_params = attributes_for(:comment, user_id: other_user.id,
        time_report_id: time_report.id)
      other_user.setting.update(comment_notice: false)
      expect {
        post v1_comments_path, params: { comment: comment_params }
      }.to_not change(other_user.notices, :count)
    end
  end

  describe '#destroy' do
    it 'コメントを削除できること' do
      comment = create(:comment, user: user)
      expect {
        delete v1_comment_path(comment)
      }.to change(user.comments, :count).by(-1)
    end
  end
end
