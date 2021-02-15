class V1::CommentsController < ApplicationController
  before_action :authorize, only: [:create, :destroy]

  def index
    comments = Comment.where(time_report_id: params[:time_report_id]).order(created_at: :desc)
    render json: comments.to_json(include: { user: { except: [:uid, :email],
      methods: :avatar_url } },
      methods: :likes_count)
  end

  def create
    comment = current_user.comments.create(comment_params)
    if comment.save
      comment.notice
      render json: comment.to_json(include: { user: { except: [:uid, :email], methods: :avatar_url }},
        methods: :likes_count)
    end
  end

  def destroy
    comment = Comment.includes(:notices).find(params[:id])
    comment.destroy!
    render json: comment.to_json(include: { user: { except: [:uid, :email], methods: :avatar_url }},
      methods: :likes_count)
  end

  private def comment_params
    params.require(:comment).permit(:content, :time_report_id)
  end
end
