class V2::UsersController < ApplicationController

  def index
    if params[:uid]
      user = User.find_by(uid: params[:uid])
      render json: user.to_json(except: [:uid, :email])
    end
  end

  def show
    if user = User.find(params[:id])
      render json: user.to_json(methods: :avatar_url, except: [:uid, :email])
    end
  end

  def create
    user = User.new(user_params)
    user.random_screen_name
    if user.save && user.create_experience! && user.create_setting!
      render json: user.to_json(methods: :avatar_url, except: [:uid, :email]), status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def avatar_url
    user = User.find(params[:id])
    render json: user.avatar_url.to_json
  end

  def following_count
    user = User.find(params[:id])
    render json: user.following_count
  end

  def follower_count
    user = User.find(params[:id])
    render json: user.follower_count
  end

  private def user_params
    params.require(:user).permit(
      :name, :email, :screen_name, :uid, :avatar, :profile
    )
  end
end
