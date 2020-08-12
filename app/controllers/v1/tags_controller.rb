class V1::TagsController < ApplicationController

  def show
    tag = Tag.includes(:user_tag_relationships, :time_reports).find(params[:id])
    time_reports = tag.time_reports.newest
    render json: { tag: tag.to_json(methods:
      [:follower_count, :time_report_count]),
      time_reports: time_reports.to_json(include: [:tags, :experience_record,
      user: { methods: :avatar_url, except: [:uid, :email] }],
      methods: :likes_count)
    }
  end

  def follow
    tag = Tag.find(params[:id])
    tag.user_tag_relationships.create(user_id: params[:user_id])
    render json: tag.id
  end

  def unfollow
    tag_relation = UserTagRelationship.find_by(user_id: params[:user_id], tag_id: params[:id])
    tag_id = tag_relation.tag_id
    tag_relation.destroy!
    render json: tag_id
  end

  def following
    user = User.find(params[:user_id])
    following_tags = user.following_tags
    render json: following_tags
  end

  def search
    if params[:user_id]
      time_reports_ids = User
        .search_time_reports_in_tags(params[:user_id], params[:name])
      render json: { ids: time_reports_ids }
    else
      tags = Tag.search(params[:name])
      render json: { tags: tags.to_json(methods:
        [:follower_count, :time_report_count]) }
    end
  end
end
