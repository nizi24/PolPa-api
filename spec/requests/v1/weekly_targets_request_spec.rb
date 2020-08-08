require 'rails_helper'

RSpec.describe "V1::Users", type: :request do

  let!(:user) { create(:user) }

  describe '#create' do
    it '目標を設定できること' do
      target_time = { target_time: '7:0' }
      expect {
        post v1_user_weekly_targets_path(user.id), params: {
          target_time: target_time
        }
      }.to change(user.weekly_targets, :count).by(1)
    end
  end
end
