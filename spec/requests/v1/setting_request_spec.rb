require 'rails_helper'

RSpec.describe "V1::Settings", type: :request do

  let(:user) { create(:user, :setting) }

  describe '#update' do
    it '通知設定を変更できること' do
      setting = attributes_for(:setting, comment_notice: false)
      patch v1_user_setting_path(user.id), params: { setting: setting }
      user.setting.reload
      expect(user.setting.comment_notice).to be false
    end
  end
end
