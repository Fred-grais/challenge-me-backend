module Api
  class ApiV1Controller < ApiController
    before_action :authenticate_user!

  end
end