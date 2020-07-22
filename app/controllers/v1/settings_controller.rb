class V1::SettingsController < ApplicationController

  def edit
    user = User.find(params[:user_id])
    setting = user.setting
    render json: setting
  end

  def update
    user = User.find(params[:user_id])
    if user.setting.update(setting_params)
      setting = user.setting
      render json: setting
    end
  end

  private def setting_params
    params.require(:setting).permit(
      :comment_notice, :follow_notice,
      :comment_like_notice, :time_report_like_notice
    )
  end
end
