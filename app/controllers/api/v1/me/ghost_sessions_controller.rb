# frozen_string_literal: true

module Api
  module V1
    module Me
      class GhostSessionsController < Api::ApiV1Controller
        def create
          cookie = current_user.ghost_credentials.create_session

          response.set_cookie_header = cookie + "; Domain=blog.challenge-me.dev.com"
          render nothing: true, status: :created

        rescue GhostInterface::GhostInterfaceError => e
          render json: {
            error: e.message
          }, status: :unprocessable_entity
        end
      end
    end
  end
end
