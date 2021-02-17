class V2::BlocksController < ApplicationController
  before_action :authorize, only: [:index, :create, :destroy]

  def index
    user = current_user
    render json: user.blocking_relationships.to_json
  end

  def create
    user = User.find(params[:user_id])
    current_user.block(user)
    render json: user.id
  end

  def destroy
    user = User.find(params[:user_id])
    current_user.unblock(user)
    render json: user.id
  end

end
