module Api
  module V1
    class MeController < Api::ApiV1Controller
      before_action :authenticate_user!

    end
  end
end