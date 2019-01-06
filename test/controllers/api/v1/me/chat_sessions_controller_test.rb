require 'test_helper'

class Api::V1::Me::ChatSessionsControllerTest < ActionDispatch::IntegrationTest

  context 'create' do

    context 'Not Authenticated' do

      should 'render an unauthorized error' do
        post api_v1_me_chat_sessions_url

        assert_response :unauthorized
        assert_equal({"errors"=>["You need to sign in or sign up before continuing."]}, JSON.parse(@response.body))
      end
    end

    context 'Authenticated' do

      context 'user have a rocket chat user id' do
        setup do
          @rocket_chat_user_id = '@rocket_chat_user_id'
          User.any_instance.stubs(:create_rocket_chat_user)
          @user = FactoryBot.create(:user, rocket_chat_user_id: @rocket_chat_user_id)
        end

        should 'return a token' do
          RocketChatInterface.any_instance.stubs(:connect_to_server)
          RocketChatInterface.any_instance.stubs(:open_admin_session)
          RocketChatInterface.any_instance.stubs(:generate_auth_token_for_user).returns('stubbed_token')

          authenticate_user(@user) do |authentication_headers|
            post api_v1_me_chat_sessions_url, headers: authentication_headers
          end

          assert_response :success
          expected = {"rocketChatAuthToken"=>"stubbed_token"}
          assert_equal(expected, JSON.parse(@response.body))
        end
      end

      context 'user does not have a rocket chat user id' do
        setup do
          @rocket_chat_user_id = nil
          @user = FactoryBot.create(:user, rocket_chat_user_id: @rocket_chat_user_id)
        end

        should 'return a token' do
          RocketChatInterface.any_instance.stubs(:connect_to_server)
          RocketChatInterface.any_instance.stubs(:open_admin_session)
          RocketChatInterface.any_instance.stubs(:generate_auth_token_for_user).returns('stubbed_token')

          authenticate_user(@user) do |authentication_headers|
            post api_v1_me_chat_sessions_url, headers: authentication_headers
          end

          assert_response :unprocessable_entity
          expected = {"error"=>"rocket_chat_user_id_missing"}
          assert_equal(expected, JSON.parse(@response.body))
        end
      end
    end
  end
end