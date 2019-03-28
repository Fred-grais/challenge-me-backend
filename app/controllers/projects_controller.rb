# frozen_string_literal: true

class ProjectsController < ApplicationController
  include DefaultErrorsHandling

  before_action :set_project, only: [:show]

  def index
    @projects = Project.includes(:user).all.order(id: :asc)

    render json: @projects.as_json(preview: true, for_front: true)
  end

  def show
    render json: @project.as_json(for_front: true)
  end

  private

    def set_project
      @project = Project.includes(:user).find(params[:id])

      if @project.blank?
        render_resource_not_found
      end
      end
end
