class V1::UsersController < ApplicationController

  def index
    if params[:uid]
      @user = User.join_exp.find_by(uid: params[:uid])
      likes = @user.likes
      render json: { user: @user,
        likes: likes.to_json(only: [:likeable_type, :likeable_id])
      }
    end
  end

  def show
    @user = User.join_exp.find(params[:id])
    main_tags = User.main_tags(params[:id])
    required_exp = RequiredExp.find_by(level: @user.level)
    if @user
      render json: { user: @user.to_json(include: { time_reports: { include:
        [:experience_record, :tags,
        comments: { include: { user: { except: [:uid, :email]}},
        methods: :likes_count }],
        methods: :likes_count }},
        except:  [:uid, :email]),
        required_exp: required_exp,
        main_tags: main_tags}
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
