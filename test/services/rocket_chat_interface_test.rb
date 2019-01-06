require 'test_helper'

class RocketChatInterfaceTest < ActiveSupport::TestCase

  test '#new should make the right calls to the server' do
    stub_request(:post, "#{ENV['ROCKET_CHAT_SERVER_URL']}/api/v1/login").
        with(
            body: "{\"username\":\"#{ENV['ROCKET_CHAT_ADMIN_USERNAME']}\",\"password\":\"#{ENV['ROCKET_CHAT_ADMIN_PASSWORD']}\"}",
            headers: {
                'Accept'=>'*/*',
                'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'Content-Type'=>'application/json',
                'User-Agent'=>'Ruby'
            }).
        to_return(status: 200, body: {success: true, data: []}.to_json, headers: {})

    RocketChatInterface.new
  end

  test '#create_user should call correctly the server' do

    stub_request(:post, "#{ENV['ROCKET_CHAT_SERVER_URL']}/api/v1/login").
        with(
            body: "{\"username\":\"#{ENV['ROCKET_CHAT_ADMIN_USERNAME']}\",\"password\":\"#{ENV['ROCKET_CHAT_ADMIN_PASSWORD']}\"}",
            headers: {
                'Accept'=>'*/*',
                'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'Content-Type'=>'application/json',
                'User-Agent'=>'Ruby'
            }).
        to_return(status: 200, body: {success: true, data: []}.to_json, headers: {})

    user = FactoryBot.create(:user)
    SecureRandom.expects(:hex).with(16).returns('123')
    stub_request(:post, "#{ENV['ROCKET_CHAT_SERVER_URL']}/api/v1/users.create").
        with(
            body: "{\"username\":\"first_name1_last_name1\",\"email\":\"1@example.com\",\"name\":\"First_name1 Last_name1\",\"password\":\"123\",\"active\":true,\"sendWelcomeEmail\":false,\"joinDefaultChannels\":true,\"customFields\":{\"app_user_id\":#{user.id}}}",
            headers: {
                'Accept'=>'*/*',
                'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'Content-Type'=>'application/json',
                'User-Agent'=>'Ruby'
            }).
        to_return(status: 200, body: {success: true, user: {_id: 123}}.to_json, headers: {})


    result =  RocketChatInterface.new.create_user(user)
    assert_equal(123, result.id)
  end

  test'#reate_user should return an error' do
    stub_request(:post, "#{ENV['ROCKET_CHAT_SERVER_URL']}/api/v1/login").
        with(
            body: "{\"username\":\"#{ENV['ROCKET_CHAT_ADMIN_USERNAME']}\",\"password\":\"#{ENV['ROCKET_CHAT_ADMIN_PASSWORD']}\"}",
            headers: {
                'Accept'=>'*/*',
                'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'Content-Type'=>'application/json',
                'User-Agent'=>'Ruby'
            }).
        to_return(status: 200, body: {success: true, data: []}.to_json, headers: {})

    user = FactoryBot.create(:user)
    SecureRandom.expects(:hex).with(16).returns('123')
    stub_request(:post, "#{ENV['ROCKET_CHAT_SERVER_URL']}/api/v1/users.create").
        to_raise(StandardError.new("some error"))


    err = assert_raises RocketChatInterface::UserCreationError do
      RocketChatInterface.new.create_user(user)
    end
    assert_equal("some error for user #{user.id}", err.message)
  end


  test '#generate_auth_token_for_user should make the correct call to the server' do
    stub_request(:post, "#{ENV['ROCKET_CHAT_SERVER_URL']}/api/v1/login").
        with(
            body: "{\"username\":\"#{ENV['ROCKET_CHAT_ADMIN_USERNAME']}\",\"password\":\"#{ENV['ROCKET_CHAT_ADMIN_PASSWORD']}\"}",
            headers: {
                'Accept'=>'*/*',
                'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'Content-Type'=>'application/json',
                'User-Agent'=>'Ruby'
            }).
        to_return(status: 200, body: {success: true, data: []}.to_json, headers: {})


    stub_request(:post, "#{ENV['ROCKET_CHAT_SERVER_URL']}/api/v1/users.createToken").
        with(
            body: "{\"userId\":\"123\"}",
            headers: {
                'Accept'=>'*/*',
                'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'Content-Type'=>'application/json',
                'User-Agent'=>'Ruby'
            }).
        to_return(status: 200, body: {success: true, data: {authToken: '147'}}.to_json, headers: {})

    result = RocketChatInterface.new.generate_auth_token_for_user('123')
    assert_equal('147', result.auth_token)
  end
 end