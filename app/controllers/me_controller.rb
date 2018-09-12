class MeController < ApplicationController
  before_action :authenticate_user!, only: [:show]

  def show
    render json: {data: current_user}
  end
end
