require 'test_helper'

class ProjectsManagement::SetupServiceTest < ActiveSupport::TestCase
  setup do
    @project = FactoryBot.create(:project)
  end

  test '#initialize' do
    service = ProjectsManagement::SetupService.new(@project)
    assert_equal(@project, service.instance_variable_get('@project'))
  end

  test '#setup' do
    service = ProjectsManagement::SetupService.new(@project)
    klipfolio_service = mock
    KlipfolioService.expects(:new).returns(klipfolio_service)

    klipfolio_service.expects(:create_client).with({name: @project.name, description: @project.description, status: KlipfolioService::DEFAULT_CLIENTS_STATUS}).returns('client_id')
    klipfolio_service.expects(:update_client_features).with('client_id', KlipfolioService::DEFAULT_CLIENTS_FEATURES)
    klipfolio_service.expects(:import_dashboard_to_client).with(KlipfolioService::DEFAULT_DASHBOARD_ID, 'client_id')
    klipfolio_service.expects(:instantiate_dashboard_on_client).with(KlipfolioService::DEFAULT_DASHBOARD_ID, 'client_id')

    service.setup_project
  end
end