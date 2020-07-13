class V1::TimeReportsController < ApplicationController

  def index
  end

  def show
    time_report = TimeReport.find(params[:id])
    user = time_report.user
    render json: { time_report: time_report.to_json(include: [:experience_record, :tags,
    comments: { include: { user: { except: [:uid, :email]}},
    methods: :likes_count }],
    methods: :likes_count ),
      user: user.to_json(except: [:uid, :email]) }
  end

  def create
    user = User.find(params[:user_id])
    time_report = user.time_reports.build(time_report_params)

    ActiveRecord::Base.transaction do
      if time_report.save!
        experience_record = ExperienceRecorder.new(user)
          .record(time_report)
        tags = TagRecorder.new(time_report).create_links(params[:tags])
        experience = Experience.find_by(user_id: user.id)
        required_exp = RequiredExp.find_by(level: experience.level)

        render json: {
          time_report: time_report.to_json(include: :comments),
          experience_record: experience_record,
          experience: experience,
          required_exp: required_exp,
          tags: tags
        }, status: :created

      else
        render json: time_report.errors, status: :unprocessable_entity
      end
    end
  end

  def update
    user = User.find(params[:user_id])
    time_report = TimeReport.find(params[:id])
    time_report.assign_attributes(time_report_params)

    ActiveRecord::Base.transaction do
      if time_report.save!
        experience_record = ExperienceRecorder.new(user)
          .record(time_report)
        tags = TagRecorder.new(time_report).create_links(params[:tags])
        experience = Experience.find_by(user_id: user.id)
        required_exp = RequiredExp.find_by(level: experience.level)

          render json: {
            time_report: time_report,
            experience_record: experience_record,
            experience: experience,
            required_exp: required_exp,
            tags: tags
          }
      end
    end
  end

  def destroy
    user = User.find(params[:user_id])
    time_report = TimeReport.includes(:likes, { comments: :likes })
      .find(params[:id])

    ActiveRecord::Base.transaction do

      ExperienceRecorder.new(user).delete_record(time_report)
      time_report.destroy!
      experience = user.experience
      required_exp = RequiredExp.find_by(level: experience.level)
      render json: {
        experience: experience,
        required_exp: required_exp
      }
    end
  end

  private def time_report_params
    params.require(:time_report).permit(:memo, :study_time)
  end
end
