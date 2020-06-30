class V1::TimeReportController < ApplicationController

  def index
  end

  def create
    time_report = TimeReport.new(time_report_params)
    if time_report.save
      render json: time_report, status: :created
    else
      render json: time_report.errors, status: :unprocessable_entity
    end
  end

  private def time_report_params
    params.require(:time_report).permit(:user_id, :memo, :study_time)
  end
end
