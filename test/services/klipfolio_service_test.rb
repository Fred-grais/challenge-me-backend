require 'test_helper'

class KlipfolioServiceTest < ActiveSupport::TestCase
  setup do
    @headers = {:"kf-api-key"=>ENV['KLIPFOLIO_API_KEY'], :"content-type"=>"application/json"}
  end

  test '#initialize' do
    service = KlipfolioService.new
    assert_equal(service.instance_variable_get('@options'), {:headers=>@headers})
  end

  test '#clients' do
    stub_get = stub_request(:get, "https://test-klipfolio-mocked.com/clients").with(headers: @headers).to_return(body: {'data' => {}}.to_json)
    service = KlipfolioService.new
    service.expects(:extract_data)
    service.clients
    assert_requested(stub_get)
  end

  test '#create_client' do
    params = {name: 'name', description: 'description', status: 'trial'}
    stub_get = stub_request(:post, "https://test-klipfolio-mocked.com/clients").with(headers: @headers, body: params.to_json).to_return(body: {'data' => {}}.to_json)
    service = KlipfolioService.new
    service.expects(:ensure_request_success)
    service.create_client(params)
    assert_requested(stub_get)
  end

  test '#dashboards' do
    stub_get = stub_request(:get, "https://test-klipfolio-mocked.com/tabs").with(headers: @headers).to_return(body: {'data' => {}}.to_json)
    service = KlipfolioService.new
    service.expects(:extract_data)
    service.dashboards
    assert_requested(stub_get)
  end

  test '#import_dashboard_to_client' do
    stub_get = stub_request(:post, "https://test-klipfolio-mocked.com/tabs/dashboard_id/@/import").with(headers: @headers, body: {client_id: 'client_id'}.to_json).to_return(body: {'data' => {}}.to_json)
    service = KlipfolioService.new
    service.expects(:ensure_request_success)
    service.import_dashboard_to_client('dashboard_id', 'client_id')
    assert_requested(stub_get)
  end

  test '#instantiate_dashboard_on_client' do
    stub_get = stub_request(:put, "https://test-klipfolio-mocked.com/users/client_id/tab-instances").with(headers: @headers, body: {tab_ids: ['dashboard_id']}.to_json).to_return(body: {'data' => {}}.to_json)
    service = KlipfolioService.new
    service.expects(:ensure_request_success)
    service.instantiate_dashboard_on_client('dashboard_id', 'client_id')
    assert_requested(stub_get)
  end

  test '#get_client_features' do
    stub_get = stub_request(:get, "https://test-klipfolio-mocked.com/clients/client_id/features").with(headers: @headers).to_return(body: {'data' => {}}.to_json)
    service = KlipfolioService.new
    service.expects(:extract_data)
    service.get_client_features('client_id')
    assert_requested(stub_get)
  end

  test '#update_client_features' do
    stub_get = stub_request(:put, "https://test-klipfolio-mocked.com/clients/client_id/features").with(headers: @headers, body: {features: 'features'}.to_json).to_return(body: {'data' => {}}.to_json)
    service = KlipfolioService.new
    service.expects(:ensure_request_success)
    service.update_client_features('client_id', 'features')
    assert_requested(stub_get)
  end

  test '#ensure_request_success' do
    stub_request(:get, "http://test.com").to_return(status: 403, body: {meta: {error_desc: 'error'}}.to_json, headers: {'Content-Type': 'application/json'})

    service = KlipfolioService.new

    exception = assert_raises(KlipfolioService::ResponseError) do
      service.send(:ensure_request_success, HTTParty.get('http://test.com'))
    end

    assert_equal( 'Klipfolio error 403 => {"error_desc"=>"error"}', exception.message )
  end

  test '#extract_data' do
    stub_request(:get, "http://test.com").to_return(status: 200, body: {data: {key: 'response'}}.to_json, headers: {'Content-Type': 'application/json'})

    service = KlipfolioService.new
    result = service.send(:extract_data, HTTParty.get('http://test.com'), :key)
    assert_equal('response', result)
  end

  test '#extract_data with error' do
    stub_request(:get, "http://test.com").to_return(status: 403, body: {meta: {error_desc: 'error'}}.to_json, headers: {'Content-Type': 'application/json'})

    service = KlipfolioService.new
    exception = assert_raises(KlipfolioService::ResponseError) do
      service.send(:extract_data, HTTParty.get('http://test.com'), :key)
    end

    assert_equal( 'Klipfolio error 403 => {"error_desc"=>"error"}', exception.message )
  end
end