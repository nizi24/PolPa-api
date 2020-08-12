class V1::CommentsController < ApplicationController

  def index
    comments = Comment.where(time_report_id: params[:time_report_id])
    render json: comments.to_json(include: { user: { except: [:uid, :email],
      methods: :avatar_url } },
      methods: :likes_count)
  end

  def create
    comment = Comment.new(comment_params)
    if comment.save
      comment.notice
      render json: comment.to_json(include: { user: { except: [:uid, :email] }},
        methods: :likes_count)
    end
  end

  def destroy
    comment = Comment.includes(:notices).find(params[:id])
    comment.destroy!
  end

  private def comment_params
    params.require(:comment).permit(:content, :user_id, :time_report_id)
  end
end
