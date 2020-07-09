require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let(:user) { create(:user) }
  let(:time_report) { create(:time_report) }

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
  end
end
