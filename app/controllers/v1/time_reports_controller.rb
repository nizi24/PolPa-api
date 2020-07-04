class V1::TimeReportsController < ApplicationController

  def index
  end

  def create
    current_user = User.find(params[:user_id])
    time_report = current_user.time_reports.build(time_report_params)

    ActiveRecord::Base.transaction do

      if time_report.save!

        experience_record = ExperienceRecorder.new(current_user)
          .record(time_report)
        experience = Experience.find_by(user_id: current_user.id)
        required_exp = RequiredExp.find_by(level: experience.level)

        render json: {
          time_report: time_report,
          experience_record: experience_record,
          experience: experience,
          required_exp: required_exp
        }, status: :created

      else
        render json: time_report.errors, status: :unprocessable_entity
      end
    end
  end


  private def time_report_params
    params.require(:time_report).permit(:memo, :study_time)
  end
end
