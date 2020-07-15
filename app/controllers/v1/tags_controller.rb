class V1::TagsController < ApplicationController

  def search
    time_reports_ids = User
      .search_time_reports_in_tags(params[:user_id], params[:name])
    render json: { ids: time_reports_ids }
  end
end
