# frozen_string_literal: true

module Api
  class ApiV1Controller < ApiController
    before_action :authenticate_user!
  end
end
