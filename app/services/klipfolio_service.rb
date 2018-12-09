class KlipfolioService
  include HTTParty

  class KlipfolioError < StandardError; end
  class ResponseError < KlipfolioError; end

  base_uri ENV['KLIPFOLIO_BASE_API']

  DEFAULT_DASHBOARD_ID = 'ca6863a6bd653fc62fc041f94a1cf4b2'
  DEFAULT_CLIENTS_STATUS = 'trial'
  DEFAULT_CLIENTS_FEATURES = [
    {
      "name":"published_dashboards",
      "enabled":true
    }
  ]

  def initialize
    @options = { headers: { 'kf-api-key': ENV['KLIPFOLIO_API_KEY'], 'content-type': 'application/json' } }
  end

  def clients
    extract_data(self.class.get('/clients', @options), :clients)
  end

  def create_client(params)
    ensure_request_success(self.class.post('/clients', {body: params.to_json}.merge(@options)))
  end

  def dashboards
    extract_data(self.class.get('/tabs', @options), :tabs)
  end

  def import_dashboard_to_client(dashboard_id, client_id)
    ensure_request_success(self.class.post("/tabs/#{dashboard_id}/@/import", {body: {client_id: client_id}.to_json}.merge(@options)))
  end

  def instantiate_dashboard_on_client(dashboard_id, client_id)
    ensure_request_success(self.class.put("/users/#{client_id}/tab-instances", {body: {tab_ids: [dashboard_id]}.to_json}.merge(@options)))
  end

  def get_client_features(client_id)
    extract_data(self.class.get("/clients/#{client_id}/features", @options), :features)
  end

  def update_client_features(client_id, features)
    ensure_request_success(self.class.put("/clients/#{client_id}/features", {body: {features: features}.to_json}.merge(@options)))
  end

  private

  def extract_data(request, key)
    ensure_request_success(request) do |parsed_response|
      parsed_response['data'][key.to_s]
    end
  end

  def ensure_request_success(request)
    result = request
    response_code = result.code
    parsed_response = result.parsed_response

    if response_code >= 200 && response_code < 300
      if block_given?
        yield(parsed_response)
      else
        true
      end
    else
      raise ResponseError.new("Klipfolio error #{response_code} => #{parsed_response['meta']}")
    end
  end
end

