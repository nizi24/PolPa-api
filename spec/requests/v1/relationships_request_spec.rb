require 'rails_helper'

RSpec.describe "V1::Relationships", type: :request do

  let(:user) { create(:user) }
  let(:other_user) { create(:user, :setting) }

  describe '#create' do
    it 'フォローに成功すること' do
      expect {
        post follow_v1_user_path(other_user.id), params: {
          current_user_id: user.id
        }
      }.to change(other_user.followers, :count).by(1)
    end

    it 'フォローされたとき通知が送信されること' do
      expect {
        post follow_v1_user_path(other_user.id), params: {
          current_user_id: user.id
        }
      }.to change(other_user.notices, :count).by(1)
    end
  end

  describe '#destroy' do
    it 'フォロー解除に成功すること' do
      user.follow(other_user)
      expect {
        delete unfollow_v1_user_path(other_user.id), params: {
          current_user_id: user.id
        }
      }.to change(other_user.followers, :count).by(-1)
    end
  end
end
