require 'test_helper'

module ApplicationCable
  class ConnectionTest < ActionCable::Connection::TestCase
    def test_connects_with_auth_params
      # Simulate a connection
      user = FactoryBot.create(:user)
      token_infos = user.create_new_auth_token

      auth = "Bearer;#{token_infos['access-token']};#{token_infos['client']};#{user.uid};#{token_infos['expiry']}"
      connect "/cable?auth=#{Base64.encode64(auth)}"

      # Asserts that the connection identifier is correct
      assert_equal user.id, connection.current_user.id
    end

    def test_does_not_connect_with_invalid_token
      user = FactoryBot.create(:user)

      auth = "Bearer;invalid;invalid;#{user.uid};invalid"

      assert_reject_connection do
        connect "/cable?auth=#{Base64.encode64(auth)}"
      end
    end
  end
end