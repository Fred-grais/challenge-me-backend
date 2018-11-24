require 'test_helper'

class Project::KpisControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project_kpi = project_kpis(:one)
  end

  test "should get index" do
    get project_kpis_url, as: :json
    assert_response :success
  end

  test "should create project_kpi" do
    assert_difference('Project::Kpi.count') do
      post project_kpis_url, params: { project_kpi: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show project_kpi" do
    get project_kpi_url(@project_kpi), as: :json
    assert_response :success
  end

  test "should update project_kpi" do
    patch project_kpi_url(@project_kpi), params: { project_kpi: {  } }, as: :json
    assert_response 200
  end

  test "should destroy project_kpi" do
    assert_difference('Project::Kpi.count', -1) do
      delete project_kpi_url(@project_kpi), as: :json
    end

    assert_response 204
  end
end
