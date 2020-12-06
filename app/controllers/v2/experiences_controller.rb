class V2::ExperiencesController < ApplicationController

  def show
    experience = Experience.find_by(user_id: params[:user_id])
    render json: experience
  end

end
