class V1::UsersController < ApplicationController

  def index
    if params[:uid]
      @user = User.join_exp.find_by(uid: params[:uid])
      render json: @user
    else
      @users = User.all
      render json: @users
    end
  end

  def show
    @user = User.join_exp.find(params[:id])
    @time_reports = @user.time_reports.join_exp.join_tags.newest
    @required_exp = RequiredExp.find_by(level: @user.level)
    if @user
      render json: {
        user: @user,
        time_reports: @time_reports,
        required_exp: @required_exp
      }
    end
  end

  def create
    user = User.new(user_params)
    if user.save && user.create_experience!
      user = User.join_exp.find(user.id)
      render json: user, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  private def user_params
    params.require(:user).permit(:name, :email, :screen_name, :uid)
  end
end
