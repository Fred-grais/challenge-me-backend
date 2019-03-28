# frozen_string_literal: true

module Api
  module V1
    module Me
      module Projects
        class PicturesUploadsController < Api::V1::MeController
          before_action :set_project_and_check_user, only: [:create]

          def create
            @project.pictures.attach(upload_pictures_params[:pictures])

            render json: {
              picturesUrls: @project.pictures_urls
            }
          end

          private

            def set_project_and_check_user
              @project = Project.find(params[:id])
              if @project.user_id != current_user.id
                render_user_forbidden_error
              end
            end

            def upload_pictures_params
              params.permit(pictures: [])
            end
        end
      end
    end
  end
end
