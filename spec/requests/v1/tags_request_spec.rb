require 'rails_helper'

RSpec.describe "V1::Tags", type: :request do
  let(:user) { create(:user) }

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
