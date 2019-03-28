# frozen_string_literal: true

module DefaultErrorsHandling
  extend ActiveSupport::Concern

  def render_user_forbidden_error
    render json: {
        success: false,
        errors: ["You are not allowed to perform this action"]
    }, status: :forbidden

    false
  end

  def render_resource_not_found
    render json: {
        success: false,
        errors: ["The resource you are trying ro access was not found on the server"]
    }, status: :not_found

    false
  end
end
