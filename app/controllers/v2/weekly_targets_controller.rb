class V2::WeeklyTargetsController < ApplicationController

  def index
    user = User.find(params[:user_id])
    weekly_targets = user.weekly_targets.order(created_at: :desc)
    render json: weekly_targets.to_json(include:
      :weekly_target_experience_record)
  end

  def show
    user = User.find(params[:user_id])
    render json: user.target_of_the_week.first
  end

  def create
    user = User.find(params[:user_id])
    weekly_target = user.weekly_targets.build(
      target_time: params[:target_time],
      start_date: Time.current.beginning_of_week,
      end_date: Time.current.end_of_week
    )
    WeeklyTargetProcessor.new(user).totalization(weekly_target)
    if weekly_target.save!
      render json: weekly_target
    end
  end
end
