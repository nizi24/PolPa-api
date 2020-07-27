class V1::FeedsController < ApplicationController

  def timeline
    user = User.find(params[:current_user_id])
    if params[:offset]
      timeline = user.timeline(params[:offset])
    else
      timeline = user.timeline
    end

    if user.following.blank?
      render plain: 'フォローしていません'
    elsif timeline.blank?
      render plain: '投稿がありません'
    else
      render json: { time_reports: timeline.to_json(include:
        [:experience_record, :tags,
        { user: { methods: :avatar_url, except: [:email, :uid] } }],
        methods: [:likes_count, :comments_count])
      }
    end
  end

  def tag_feed
    user = User.find(params[:current_user_id])
    if params[:offset]
      tag_feed = user.tag_feed(params[:offset])
    else
      tag_feed = user.tag_feed
    end
    if UserTagRelationship.find_by(user_id: params[:current_user_id]).blank?
      render plain: 'フォローしていません'
    elsif tag_feed.blank?
      render plain: '投稿がありません'
    else
      render json: { time_reports: tag_feed.to_json(include: [:experience_record, :tags,
      { user: { methods: :avatar_url, except: [:email, :uid] } }],
      methods: [:likes_count, :comments_count])
      }
    end
  end
end
