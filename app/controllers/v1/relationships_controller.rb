class V1::RelationshipsController < ApplicationController
  def create
    current_user = User.find(params[:current_user_id])
    @user = User.find(params[:id])
    current_user.follow(@user)
    Relationship.find_by(followed_id: @user.id, follower_id: params[:current_user_id]).notice
    render json: @user.id
  end

  def destroy
    current_user = User.find(params[:current_user_id])
    @user = User.find(params[:id])
    relationship = Relationship.find_by(followed_id: @user.id, follower_id: params[:current_user_id])
    current_user.unfollow(@user)
    relationship.destroy! if relationship
    render json: @user.id
  end
end
