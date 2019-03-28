module Api
  module V1
    module Me
      class ProjectsController < Api::V1::MeController
        include DefaultErrorsHandling

        before_action :set_project_and_check_user, only: [:show, :update, :destroy]

        def index
          render json: current_user.projects.with_attached_logo.as_json(preview: true, for_front: true)
        end

        # GET /projects/1
        def show
          render json: @project.as_json(for_front: true)
        end

        # POST /projects
        def create
          @project = current_user.projects.new(project_params)

          if @project.save
            render json: @project.as_json(preview: true, for_front: true), status: :created, location: api_v1_me_project_url(@project)
          else
            render json: @project.errors.full_messages, status: :unprocessable_entity
          end
        end

        # PATCH/PUT /projects/1
        def update
          if @project.update(project_params)
            render json: @project.as_json(for_front: true)
          else
            render json: @project.errors.full_messages, status: :unprocessable_entity
          end
        end

        # DELETE /projects/1
        def destroy
          @project.destroy
        end

        private

          # Use callbacks to share common setup or constraints between actions.
          def set_project_and_check_user
            @project = Project.includes(:activity_sectors).find(params[:id])
            if @project.user_id != current_user.id
              render_user_forbidden_error
            end
          end

          # Only allow a trusted parameter "white list" through.
          def project_params
            params.require(:project).permit(:name, :description, activity_sector_list: [], challenges_needed_list: [], timeline: [items: [:title, :description, :date, :image_url]])
          end
      end
    end
  end
end