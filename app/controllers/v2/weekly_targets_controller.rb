class V2::WeeklyTargetsController < ApplicationController

  def show
    user = User.find(params[:user_id])
    render json: user.target_of_the_week.first
  end
end
