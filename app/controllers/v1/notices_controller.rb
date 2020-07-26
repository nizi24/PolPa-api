class V1::NoticesController < ApplicationController

  def index
    user = User.find(params[:user_id])
    if params[:limit]
      notices = user.notice
      render json: notices.to_json(include: { action_user: {
        methods: :avatar_url, except: [:uid, :email] } })
    else
      render json: user.to_json(include: { notices: { include: :action_user } },
        only: :id
      )
    end
  end

  def check
    user = User.find(params[:user_id])
    user.notices.where(checked: false).each do |notice|
      notice.checked = true
      notice.save!
    end
    render json: user.notice
  end
end
