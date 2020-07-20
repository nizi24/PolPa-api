class V1::RelationshipsController < ApplicationController
  def create
    current_user = User.find(params[:current_user_id])
    @user = User.find(params[:user_id])
    current_user.follow(@user)
    render status: 201
  end

  def destroy
    current_user = User.find(params[:current_user_id])
    @user = User.find(params[:user_id])
    current_user.unfollow(@user)
    render status: 200
  end
end
