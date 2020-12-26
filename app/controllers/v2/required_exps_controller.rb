class V2::RequiredExpsController < ApplicationController

  def show
    required_exp = RequiredExp.find_by(level: params[:level])
    render json: required_exp
  end

end
