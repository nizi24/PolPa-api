class V1::FeedsController < ApplicationController

  def timeline
    user = User.find(params[:current_user_id])
    if params[:offset]
      timeline = user.timeline(params[:offset])
    else
      timeline = user.timeline
    end
    render json: { time_reports: timeline.to_json(include: [:experience_record, :tags,
    { user: { methods: :avatar_url, except: [:email, :uid] } }],
    methods: :likes_count)
    }
  end

  def tag_feed
    user = User.find(params[:current_user_id])
    if params[:offset]
      tag_feed = user.tag_feed(params[:offset])
    else
      tag_feed = user.tag_feed
    end
    render json: { time_reports: tag_feed.to_json(include: [:experience_record, :tags,
    { user: { methods: :avatar_url, except: [:email, :uid] } }],
    methods: :likes_count)
    }
  end
end
