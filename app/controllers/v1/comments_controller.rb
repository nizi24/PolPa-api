class V1::CommentsController < ApplicationController

  def create
    comment = Comment.new(comment_params)
    if comment.save
      render json: comment.to_json(include: { user: { except: [:uid, :email]}},
        methods: :likes_count)
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy!
  end

  private def comment_params
    params.require(:comment).permit(:content, :user_id, :time_report_id)
  end
end
