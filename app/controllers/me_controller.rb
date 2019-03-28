class MeController < ApplicationController
  before_action :authenticate_user!, only: [:show]

  def show
    render json: {data: current_user.as_json(for_front: true)}
  end
end
