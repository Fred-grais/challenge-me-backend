class OmniauthController < ApplicationController

  def create
    xx
    render json: true
  end

  def failure
    xx
    puts request.env['omniauth.auth']
  end
end
