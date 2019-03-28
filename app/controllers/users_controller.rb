class UsersController < ApplicationController
  include DefaultErrorsHandling

  before_action :set_user, only: [:show]

  def index
    @users = User.includes(:rocket_chat_details).all.with_attached_avatar

    render json: @users.as_json(preview: true, for_front: true)
  end

  def show
    render json: @user.as_json(for_front: true)
  end

  private

  def set_user
    @user = User.find(params[:id])

    unless @user
      render_resource_not_found
    end
  end
end
