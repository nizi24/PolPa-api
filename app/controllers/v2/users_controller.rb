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

  def update
    user = User.find(params[:id])
    if !user.guest && user.update(user_params)
      render json: user.to_json(methods: :avatar_url, except: [:uid, :email])
    end
  end

  def update_avatar
    user = User.find(params[:id])
    user.avatar.attach(params[:file]) if !user.guest
    render json: user.to_json(methods: :avatar_url, except: [:uid, :email])
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

  def tag_following_count
    user = User.find(params[:id])
    render json: user.user_tag_relationships.count
  end

  def experience_rank
    if params[:weekly]
      term = Time.current.beginning_of_week
    elsif params[:monthly]
      term = Time.current.beginning_of_month
    end
    users = User.experience_rank(term)
    render json: users.to_json(methods: :avatar_url,
      except: [:uid, :email])
  end

  def is_following
    user = User.find(params[:id])
    current_user = User.find(params[:current_user_id])
    render json: current_user.following?(user)
  end

  def search
    users = User.search(params[:word])
    if params[:word].gsub!(/\A@/, '')
      users += User.screen_name_search(params[:word])
    end
    render json: users.to_json(methods: :avatar_url,
      except: [:uid, :email], include: :experience)
  end

  def email_already_used
    if params[:id]
      current_user = User.find(params[:id])
      user = User.find_by(email: params[:email])
      render json: !(current_user == user || user.nil?)
    else
      user = User.find_by(email: params[:email])
      render json: !user.nil?
    end
  end

  def screen_name_already_used
    current_user = User.find(params[:id])
    user = User.find_by(screen_name: params[:screen_name])
    if current_user == user || user.nil?
      render json: false
    else
      render json: true
    end
  end

  def main_tags
    main_tags = User.main_tags(params[:id])
    main_tags = main_tags.filter { |tag| tag.id }
    render json: main_tags.to_json
  end

  def following_tags
    user = User.includes(:user_tag_relationships).find(params[:id])
    following_tags = user.tags
    render json: following_tags.to_json
  end

  def following
    user = User.find(params[:id])
    following = user.following
    render json: following.to_json(methods: :avatar_url,
      except: [:uid, :email], include: :experience)
  end

  def followers
    user = User.find(params[:id])
    follower = user.followers
    render json: follower.to_json(methods: :avatar_url,
      except: [:uid, :email], include: :experience)
  end

  def prev_weekly_target
    user = User.find(params[:id])
    prev_weekly_target = user.target_of_non_checked
    render json: prev_weekly_target
  end

  def email
    user = User.find_by(uid: params[:uid])
    render json: user.email.to_json
  end

  private def user_params
    params.require(:user).permit(
      :name, :email, :screen_name, :uid, :avatar, :profile
    )
  end
end
