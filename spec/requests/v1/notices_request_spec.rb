require 'rails_helper'

RSpec.describe "V1::Notices", type: :request do
  let(:user) { create(:user, :setting) }
  let(:other_user) { create(:user, :setting) }

  describe '#check' do
    it '全ての通知をチェック済みにすること' do
      time_report = create(:time_report, user: other_user)
      comments = create_list(:comment, 3, time_report: time_report)
      comments.map(&:notice)
      get check_v1_user_notices_path(user.id)
      expect(user.notice_nonchecked).to eq []
    end
  end
end
