class V1::TimeReportsController < ApplicationController
  before_action :authorize, only: [:create, :update, :destroy]

  def index
    if params[:offset]
      time_reports = TimeReport.limit(30)
        .offset(params[:offset]).order(study_date: :desc)
    else
      time_reports = TimeReport.limit(30).order(study_date: :desc)
    end
    render json: { time_reports: time_reports.to_json(include: [:experience_record, :tags,
    { user: { methods: :avatar_url, except: [:email, :uid] } }],
    methods: [:likes_count, :comments_count]) }
  end

  def show
    time_report = TimeReport.find(params[:id])
    user = time_report.user
    render json: { time_report: time_report.to_json(include: [:experience_record, :tags],
    methods: [:likes_count, :comments_count]),
      user: user.to_json(except: [:uid, :email], methods: :avatar_url) }
  end

  def create
    user = current_user
    time_report = user.time_reports.build(time_report_params)

    ActiveRecord::Base.transaction do
      if time_report.save!
        experience_record = ExperienceRecorder.new(user)
          .record(time_report)
        tags = TagRecorder.new(time_report).create_links(params[:tags])
        experience = Experience.find_by(user_id: user.id)
        required_exp = RequiredExp.find_by(level: experience.level)
        weekly_target = WeeklyTargetProcessor.new(user)
          .add_progress(time_report)

        render json: {
          time_report: time_report.to_json(include: [:experience_record, :tags,
          comments: { methods: :likes_count },
          user: { methods: :avatar_url, except: [:uid, :email] }],
          methods: [:likes_count, :comments_count] ),
          experience: experience,
          required_exp: required_exp,
          weekly_target: weekly_target
        }, status: :created

      else
        render json: time_report.errors, status: :unprocessable_entity
      end
    end
  end

  def update
    user = current_user
    time_report = TimeReport.find(params[:id])
    WeeklyTargetProcessor.new(user).sub_progress(time_report)
    time_report.assign_attributes(time_report_params)

    ActiveRecord::Base.transaction do
      if time_report.save!
        experience_record = ExperienceRecorder.new(user)
          .record(time_report)
        tags = TagRecorder.new(time_report).create_links(params[:tags])
        experience = Experience.find_by(user_id: user.id)
        required_exp = RequiredExp.find_by(level: experience.level)
        weekly_target = WeeklyTargetProcessor.new(user)
          .add_progress(time_report)

          render json: {
            time_report: time_report.to_json(include: [:experience_record, :tags, user: { methods: :avatar_url, except: [:uid, :email] }],
            methods: [:likes_count, :comments_count] ),
            experience: experience,
            required_exp: required_exp,
            weekly_target: weekly_target
          }
      end
    end
  end

  def destroy
    user = current_user
    time_report = TimeReport.includes(:likes, { comments: [:likes, :notices] })
      .find(params[:id])
    weekly_target = WeeklyTargetProcessor.new(user).sub_progress(time_report)

    ActiveRecord::Base.transaction do
      ExperienceRecorder.new(user).delete_record(time_report)
      time_report.destroy!
      experience = user.experience
      required_exp = RequiredExp.find_by(level: experience.level)
      render json: {
        experience: experience,
        required_exp: required_exp,
        weekly_target: weekly_target
      }
    end
  end

  def tag_search
    time_reports = TimeReport.tag_search(params[:tag_name])
    render json: { time_reports: time_reports.to_json(include: [:experience_record, :tags,
    user: { methods: :avatar_url, except: [:uid, :email] }],
    methods: [:likes_count, :comments_count] ) }
  end

  private def time_report_params
    params.require(:time_report).permit(:memo, :study_time, :study_date)
  end
end
