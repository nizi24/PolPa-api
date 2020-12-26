class V2::TimeReportsController < ApplicationController

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      if params[:limit]
        render json: user.time_reports.limit(params[:limit]).to_json(include: [:experience_record, :tags,
          { user: { methods: :avatar_url, except: [:email, :uid] } }],
          methods: [:likes_count, :comments_count])
      elsif params[:offset]
        render json: user.time_reports.limit(30)
          .offset(params[:offset]).to_json(include: [:experience_record, :tags,
          { user: { methods: :avatar_url, except: [:email, :uid] } }],
          methods: [:likes_count, :comments_count])
      else
        render json: user.time_reports.limit(30).to_json(include: [:experience_record, :tags,
        { user: { methods: :avatar_url, except: [:email, :uid] } }],
        methods: [:likes_count, :comments_count])
      end
    elsif params[:tag_id]
      tag = Tag.includes(:user_tag_relationships, :time_reports).find(params[:tag_id])
      time_reports = tag.time_reports.newest
      if params[:limit]
        render json: time_reports.limit(params[:limit]).to_json(include: [:experience_record, :tags,
          { user: { methods: :avatar_url, except: [:email, :uid] } }],
          methods: [:likes_count, :comments_count])
      elsif params[:offset]
        render json: time_reports.limit(30)
          .offset(params[:offset]).to_json(include: [:experience_record, :tags,
          { user: { methods: :avatar_url, except: [:email, :uid] } }],
          methods: [:likes_count, :comments_count])
      else
        render json: time_reports.limit(30).to_json(include: [:experience_record, :tags,
        { user: { methods: :avatar_url, except: [:email, :uid] } }],
        methods: [:likes_count, :comments_count])
      end
    else
      time_reports = TimeReport.all.order(study_date: :desc)
      if params[:limit]
        render json: time_reports.limit(params[:limit]).to_json(include: [:experience_record, :tags,
          { user: { methods: :avatar_url, except: [:email, :uid] } }],
          methods: [:likes_count, :comments_count])
      elsif params[:offset]
        render json: time_reports.limit(30)
          .offset(params[:offset]).to_json(include: [:experience_record, :tags,
          { user: { methods: :avatar_url, except: [:email, :uid] } }],
          methods: [:likes_count, :comments_count])
      else
        render json: time_reports.limit(30).to_json(include: [:experience_record, :tags,
        { user: { methods: :avatar_url, except: [:email, :uid] } }],
        methods: [:likes_count, :comments_count])
      end
    end
  end

  def show
    time_report = TimeReport.find(params[:id])
    render json: time_report.to_json(include: [:experience_record, :tags,
    { user: { methods: :avatar_url, except: [:email, :uid] } }],
    methods: [:likes_count, :comments_count])
  end

  def create
    user = User.find(params[:user_id])
    time_report = user.time_reports.build(time_report_params)

    ActiveRecord::Base.transaction do
      if time_report.save!
        ExperienceRecorder.new(user).record(time_report)
        TagRecorder.new(time_report).create_links(params[:tags])
        WeeklyTargetProcessor.new(user).add_progress(time_report)

        render json: time_report.to_json(include: [:experience_record, :tags,
        { user: { methods: :avatar_url, except: [:email, :uid] } }],
        methods: [:likes_count, :comments_count])
      else
        render json: time_report.errors, status: :unprocessable_entity
      end
    end
  end

  def update
    user = User.find(params[:user_id])
    time_report = TimeReport.find(params[:id])
    WeeklyTargetProcessor.new(user).sub_progress(time_report)
    time_report.assign_attributes(time_report_params)

    ActiveRecord::Base.transaction do
      if time_report.save!
        ExperienceRecorder.new(user).record(time_report)
        TagRecorder.new(time_report).create_links(params[:tags])
        WeeklyTargetProcessor.new(user).add_progress(time_report)

        render json: time_report.to_json(include: [:experience_record, :tags,
        { user: { methods: :avatar_url, except: [:email, :uid] } }],
        methods: [:likes_count, :comments_count])
      end
    end
  end

  def destroy
    time_report = TimeReport.includes(:likes, { comments: [:likes, :notices] })
      .find(params[:id])
    user = time_report.user
    WeeklyTargetProcessor.new(user).sub_progress(time_report)

    ActiveRecord::Base.transaction do
      ExperienceRecorder.new(user).delete_record(time_report)
      time_report.destroy!
      render json: time_report.to_json(include: [:experience_record, :tags,
      { user: { methods: :avatar_url, except: [:email, :uid] } }],
      methods: [:likes_count, :comments_count])
    end
  end

  def tag_search
    if params[:user_id]
      time_report_ids = User.search_time_reports_in_tags(params[:user_id], params[:tag_name])
      if params[:offset]
        time_reports = TimeReport.where(id: time_report_ids).offset(params[:offset]).limit(30)
      else
        time_reports = TimeReport.where(id: time_report_ids).limit(30)
      end
    else
      if params[:offset]
        time_reports = TimeReport.tag_search(params[:tag_name]).offset(params[:offset]).limit(30)
      else
        time_reports = TimeReport.tag_search(params[:tag_name]).limit(30)
      end
    end
    render json: time_reports.to_json(include: [:experience_record, :tags,
    user: { methods: :avatar_url, except: [:uid, :email] }],
    methods: [:likes_count, :comments_count])
  end

  private def time_report_params
    params.require(:time_report).permit(:memo, :study_time, :study_date)
  end
end
