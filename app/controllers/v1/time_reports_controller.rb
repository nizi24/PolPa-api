class V1::TimeReportsController < ApplicationController

  def index
  end

  def create
    current_user = User.find(params[:user_id])
    time_report = current_user.time_reports.build(time_report_params)
    if time_report.save
      experience_record = ExperienceRecorder.new(current_user).record(time_report)
      render json: {
        time_report: time_report,
        experience_record: experience_record
      }, status: :created
    else
      render json: time_report.errors, status: :unprocessable_entity
    end
  end

  private def time_report_params
    params.require(:time_report).permit(:memo, :study_time)
  end
end
