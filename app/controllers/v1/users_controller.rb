class V1::UsersController < ApplicationController

  def index
    if params[:uid]
      @user = User.find_by(uid: params[:uid])
      render json: @user
    else
      @users = User.all
      render json: @users
    end
  end

  def show
    @user = User.find(params[:id])
    @time_reports = @user.time_reports.order(created_at: :desc)
    if @user
      render json: { user: @user, time_reports: @time_reports }
    end
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  private def user_params
    params.require(:user).permit(:name, :email, :screen_name, :uid)
  end
end
