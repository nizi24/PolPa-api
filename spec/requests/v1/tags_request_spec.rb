require 'rails_helper'

RSpec.describe "V1::Tags", type: :request do
  let(:user) { create(:user) }
  let(:tag) { create(:tag) }

  describe '#follow' do
    it 'タグをフォローできること' do
      expect {
        post follow_v1_tag_path(tag.id), params: { user_id: user.id }
      }.to change(user.user_tag_relationships, :count).by(1)
    end
  end

  describe '#unfollow' do
    it 'タグのフォローを解除できること' do
      post follow_v1_tag_path(tag.id), params: { user_id: user.id }
      expect {
        delete unfollow_v1_tag_path(tag.id), params: { user_id: user.id }
      }.to change(user.user_tag_relationships, :count).by(-1)
    end
  end

  describe '#search' do
    it 'タグの名前でタイムレポートを検索できること' do
      time_reports = create_list(:time_report, 3, :tags, user: user)
      get search_v1_user_tags_path(user.id), params: {
        name: 'Rails'
      }
      json = JSON.parse(response.body)
      expect(json['ids'].length).to eq 9
    end
  end
end
