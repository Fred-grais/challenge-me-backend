module Api
  module V1
    module Me
      class AvatarsUploadsController < Api::V1::MeController

        def create
          current_user.avatar.attach(upload_avatar_params[:avatar])

          render json: {
            avatarUrl: url_for(current_user.avatar_url)
          }
        end

        private

        def upload_avatar_params
          params.permit(:avatar)
        end
      end
    end
  end
end