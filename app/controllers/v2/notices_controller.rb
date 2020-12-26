class V2::NoticesController < ApplicationController

  def index
    user = User.find(params[:user_id])
    notices = user.notice
    if params[:limit]
      notices = notices.limit(params[:limit])
    elsif params[:offset]
      notices = notices.offset(params[:offset]).limit(30)
    else
      notices = notices.limit(30)
    end
    render json: notices.to_json(include: { action_user: {
      methods: :avatar_url, except: [:uid, :email] } })
  end

  def check
    user = User.find(params[:user_id])
    notices = user.notice
    notices.where(checked: false).each do |notice|
      notice.checked = true
      notice.save!
    end
    if params[:limit]
      notices = notices.limit(params[:limit])
    else
      notices = notices.limit(30)
    end
    render json: notices.to_json(include: { action_user: {
      methods: :avatar_url, except: [:uid, :email] } })
  end
end
