# frozen_string_literal: true

class ApiController < ApplicationController
  rescue_from ActionController::ParameterMissing do |exception|
    render json: {
      success: false,
      errors: [exception.message]
    }, status: :unprocessable_entity
  end
end
