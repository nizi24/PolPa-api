class V1::LikesController < ApplicationController

  def create
    like = Like.new(like_params)
    if like.save
      like.notice
      render status: :created
    end
  end

  def delete
    liked = JSON.parse(params['like'])
    like = Like.find_by(liked)
    like.destroy!
  end

  private def like_params
    params.require(:like).permit(:likeable_id, :likeable_type, :user_id)
  end
end
