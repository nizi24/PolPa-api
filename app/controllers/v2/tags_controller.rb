class V2::TagsController < ApplicationController

  def show
    tag = Tag.includes(:user_tag_relationships).find(params[:id])
    tag.current_user = User.find(params[:current_user_id])
    render json: tag.to_json(methods: [:follower_count, :time_report_count, :following?])
  end

  def search
    tags = Tag.search(params[:name])
    render json: tags.to_json(methods:
      [:follower_count, :time_report_count])
  end
end
