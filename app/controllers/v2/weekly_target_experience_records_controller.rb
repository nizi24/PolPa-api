class V2::WeeklyTargetExperienceRecordsController < ApplicationController

  def show
    weekly_target = WeeklyTarget.find(params[:weekly_target_id])
    render json: weekly_target.weekly_target_experience_record.to_json
  end
end
