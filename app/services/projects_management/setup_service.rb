module ProjectsManagement
  class SetupService

    def initialize(project)
      @project = project
    end

    # 'setup' is a reserved word
    def setup_project
      setup_klipfolio
    end

    private

    def setup_klipfolio
      klipfolio_service = KlipfolioService.new

      client_id = klipfolio_service.create_client({name: @project.name, description: @project.description, status: KlipfolioService::DEFAULT_CLIENTS_STATUS})
      klipfolio_service.update_client_features(client_id, KlipfolioService::DEFAULT_CLIENTS_FEATURES)
      klipfolio_service.import_dashboard_to_client(KlipfolioService::DEFAULT_DASHBOARD_ID, client_id)
      klipfolio_service.instantiate_dashboard_on_client(KlipfolioService::DEFAULT_DASHBOARD_ID, client_id)
    end

  end
end