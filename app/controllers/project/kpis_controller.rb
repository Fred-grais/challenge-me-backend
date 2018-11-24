class Project::KpisController < ApplicationController
  before_action :set_project_kpi, only: [:show, :update, :destroy]

  # GET /project/kpis
  def index
    @project_kpis = Project::Kpi.all

    render json: @project_kpis
  end

  # GET /project/kpis/1
  def show
    render json: @project_kpi
  end

  # POST /project/kpis
  def create
    @project_kpi = Project::Kpi.new(project_kpi_params)

    if @project_kpi.save
      render json: @project_kpi, status: :created, location: @project_kpi
    else
      render json: @project_kpi.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /project/kpis/1
  def update
    if @project_kpi.update(project_kpi_params)
      render json: @project_kpi
    else
      render json: @project_kpi.errors, status: :unprocessable_entity
    end
  end

  # DELETE /project/kpis/1
  def destroy
    @project_kpi.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_kpi
      @project_kpi = Project::Kpi.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def project_kpi_params
      params.fetch(:project_kpi, {})
    end
end
