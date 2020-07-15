require 'rails_helper'

RSpec.describe "V1::Like", type: :request do
  let(:user) { create(:user) }
  let(:time_report) { create(:time_report) }
  let(:comment) { create(:comment) }

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
