class V2::FeedsController < ApplicationController

  def timeline
    user = User.find(params[:current_user_id])
    if params[:limit]
      timeline = user.timeline(0, params[:limit])
    elsif params[:offset]
      timeline = user.timeline(params[:offset])
    else
      timeline = user.timeline
    end
    render json: timeline.to_json(include:
      [:experience_record, :tags,
      { user: { methods: :avatar_url, except: [:email, :uid] } }],
      methods: [:likes_count, :comments_count])
  end

  def tag_feed
    user = User.find(params[:current_user_id])
    if params[:limit]
      tag_feed = user.tag_feed(0, params[:limit])
    elsif params[:offset]
      tag_feed = user.tag_feed(params[:offset])
    else
      tag_feed = user.tag_feed
    end
    render json: tag_feed.to_json(include: [:experience_record, :tags,
    { user: { methods: :avatar_url, except: [:email, :uid] } }],
    methods: [:likes_count, :comments_count])
  end
end
