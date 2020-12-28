class V2::BlocksController < ApplicationController

  def index
    user = User.find(params[:user_id])
    render json: user.blocking_relationships.to_json
  end

  def create
    current_user = User.find(params[:current_user_id])
    user = User.find(params[:user_id])
    current_user.block(user)
    render json: user.id
  end

  def destroy
    current_user = User.find(params[:current_user_id])
    user = User.find(params[:user_id])
    current_user.unblock(user)
    render json: user.id
  end

end
