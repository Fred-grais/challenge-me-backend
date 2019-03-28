module Api
  module V1
    module Me
      module Projects
        class LogoUploadController < Api::V1::MeController

          before_action :set_project_and_check_user, only: [:create]

          def create
            @project.logo.attach(upload_logo_params[:logo])

            render json: {
              logoUrl: @project.logo_url
            }
          end

          private

            def set_project_and_check_user
              @project = Project.find(params[:id])
              if @project.user_id != current_user.id
                render_user_forbidden_error
              end
            end

            def upload_logo_params
              params.permit(:logo)
            end
        end
      end
    end
  end
end